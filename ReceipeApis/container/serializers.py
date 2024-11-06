from rest_framework import serializers
from container.models import *





# class UserSerializer(serializers.ModelSerializer):


#     class Meta:
#         model = User
#         fields = ['id', 'username', 'email', 'first_name', 'last_name']
class UserSerializer(serializers.ModelSerializer):
    followers_count = serializers.SerializerMethodField()
    following_count = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'followers_count', 'following_count','last_login','date_joined','is_verified','profile_image']

    def get_followers_count(self, obj):
        return FollowRelation.objects.filter(user=obj).count()

    def get_following_count(self, obj):
        return FollowRelation.objects.filter(follower=obj).count()


class UserSerializerforprofile(serializers.ModelSerializer):
    followers_count = serializers.SerializerMethodField()
    following_count = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'followers_count', 'following_count','last_login','date_joined','is_verified','profile_image']

    def get_followers_count(self, obj):
        return FollowRelation.objects.filter(user=obj).count()

    def get_following_count(self, obj):
        return FollowRelation.objects.filter(follower=obj).count()




    
class ReceipeItemForUserSerializer(serializers.ModelSerializer):
    receipe_user_id=UserSerializer()
    class Meta:
        model = Receipe
        fields = ['receipe_user_id','category_id']


class ReceipeItemSerializer(serializers.ModelSerializer):
    receipe_user_id=UserSerializer()
    class Meta:
        model = Receipe
        fields = '__all__'

class categorylistSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReceipeCategory
        fields = '__all__'


class FollowRelationSerializer(serializers.ModelSerializer):
    class Meta:
        model = FollowRelation  # Use the renamed model name
        fields = '__all__'







#-------------------On_click_Items---------------




class ReceipeProcedureSerializer(serializers.ModelSerializer):
    class Meta:
        model = Procedure
        fields = ['description', 'procedure_number']
    
    procedure_number = serializers.IntegerField(required=True)



class ReceipeCategoryDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReceipeCategory
        fields = ['category_name']


class ReceipeIngredientDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredient
        fields = ['ingredient_name','ingredient_url']

class ReceipeIngredientSerializer(serializers.ModelSerializer):
    ingredient_id=ReceipeIngredientDetailSerializer()
    class Meta:
        model = ReceipeIngredient
        fields = ['ingredient_id','amount','unit']


class ReceipeSerializer1(serializers.ModelSerializer):
    class Meta:
        model = Receipe
        fields = '__all__'


class ReceipeSerializer(serializers.ModelSerializer):

    receipe_ingredients = ReceipeIngredientSerializer(many=True, source='ingredient_receipe')
    category_id = ReceipeCategoryDetailSerializer()

    procedure_receipe = ReceipeProcedureSerializer(many=True)

    receipe_user_id = UserSerializer(required=False)

    class Meta:
        model = Receipe
        fields = '__all__'


    
    def update(self, instance, validated_data):
  
        instance.receipe_title = validated_data.get('receipe_title', instance.receipe_title)
        instance.Description = validated_data.get('Description', instance.Description)
        instance.Prep_time = validated_data.get('Prep_time', instance.Prep_time)
        instance.cook_time = validated_data.get('cook_time', instance.cook_time)
        instance.serving_quantity = validated_data.get('serving_quantity', instance.serving_quantity)
        category_data = validated_data.get('category_id')


        if category_data:
            category_name = category_data.get('category_name')
            if category_name:
                try:
                    instance.category_id = ReceipeCategory.objects.get(category_name=category_name)
                except ReceipeCategory.DoesNotExist:
                    instance.category_id = ReceipeCategory.objects.create(category_name=category_name)

                        # Access the nested serializer data and extract ingredient names

        existing_procedures = Procedure.objects.filter(receipe_id=instance)

        # Process each updated procedure
        updated_procedures = validated_data.get('procedure_receipe', [])
        for updated_procedure in updated_procedures:
            description = updated_procedure.get('description', None)
            procedure_number = updated_procedure.get('procedure_number', None)

            # Check if a procedure with the same procedure_number exists
            existing_procedure = existing_procedures.filter(procedure_number=procedure_number).first()

            if existing_procedure:
                # Update the existing procedure's description
                existing_procedure.description = description
                existing_procedure.save()
            else:
                # Create a new procedure
                Procedure.objects.create(receipe_id=instance, description=description, procedure_number=procedure_number)

        # Delete any existing procedures not present in the updated data
        for existing_procedure in existing_procedures:
            procedure_number = existing_procedure.procedure_number
            if not any(procedure['procedure_number'] == procedure_number for procedure in updated_procedures):
                existing_procedure.delete()











        receipe_ingredients_data = self.initial_data.get('receipe_ingredients', [])
        ingredient_names = [ingredient['ingredient_id']['ingredient_name'] for ingredient in receipe_ingredients_data]
        existing_ingredients = instance.ingredient_receipe.all()

      
        # Check for new ingredients and add them to the database
        for ingredient in receipe_ingredients_data:
            ingredient_name = ingredient['ingredient_id']['ingredient_name']
            ingredient_amount = ingredient['amount']
            ingredient_unit = ingredient['unit']

            # Get or create the Unit instance based on the ingredient's unit value
            unit_instance, created = Unit.objects.get_or_create(unit_name=ingredient_unit)

            # Check if the ingredient is not already in the database
            if ingredient_name not in [i.ingredient_id.ingredient_name for i in existing_ingredients]:
           
                # Create and associate the new ingredient with the Receipe instance
                new_ingredient = Ingredient.objects.create(ingredient_name=ingredient_name)
                ReceipeIngredient.objects.create(receipe_id=instance, ingredient_id=new_ingredient, amount=ingredient_amount, unit=unit_instance)

        # Check for existing ingredients not present in the input data and delete them
        for ingredient in existing_ingredients:
            if ingredient.ingredient_id.ingredient_name not in ingredient_names:
                ingredient_name = ingredient.ingredient_id.ingredient_name
                ingredient.delete()
                
        
  
        instance.save()
        return instance