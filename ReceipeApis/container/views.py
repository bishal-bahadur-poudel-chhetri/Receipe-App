from django.shortcuts import render
from django.http import Http404, HttpResponseBadRequest, JsonResponse
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from accounts.models import Account
from container.serializers import *
from container.models import *
from container.permissions import IsOwner
from django.db.models import Count, F, Q


class checklistapi(APIView):
    permission_classes=[IsAuthenticated,IsOwner]
    serializers_class=ReceipeItemSerializer
    def get(self,request,format=None):
        category_choice = request.query_params.get('category', None)
        uid_choice = request.query_params.get('id', None)
        user_receipe = request.query_params.get('user', None)
        choice_type=request.query_params.get('usertype', None)


        if category_choice:
            try:

                data = Receipe.objects.filter(Q(category_id=category_choice) & ~Q(receipe_user_id=request.user))
                print(data)
            except:
                error_response = {'error': 'Invalid category'}
                return JsonResponse(error_response, status=400)
        elif uid_choice and user_receipe:

            data = Receipe.objects.filter(Q(receipe_user_id=user_receipe) & ~Q(receipe_id=uid_choice))
        elif choice_type:
            if choice_type=="self":
                data = Receipe.objects.filter(Q(receipe_user_id=request.user))
            elif choice_type=="other":
               
                data = Receipe.objects.annotate(popularity_score=Count('popularity')).order_by('-popularity_score')
                data = data.filter(~Q(receipe_user_id=request.user))


        else:
            
            data=Receipe.objects.filter(~Q(receipe_user_id=request.user))
        
        serializer=self.serializers_class(data,many=True)
        seralized_data=serializer.data
        return Response(seralized_data,status=status.HTTP_200_OK)
    




class categorylist(APIView):
    permission_classes=[IsAuthenticated,IsOwner]
    serializers_class=categorylistSerializer
    p_serializers_class=ReceipeSerializer1
    def get(self,request,format=None):
        
        data=ReceipeCategory.objects.all()

        serializer=self.serializers_class(data,many=True)
        seralized_data=serializer.data
        return Response(seralized_data,status=status.HTTP_200_OK)
    
class CategoryListDetail(APIView):
    permission_classes = [IsAuthenticated, IsOwner]
    serializer_class = ReceipeSerializer

    def get_object(self, uuid_check):
        try:
            return Receipe.objects.get(receipe_id=uuid_check)
        except Receipe.DoesNotExist:
            return None

    def get(self, request, uuid_check, format=None):
        receipe = self.get_object(uuid_check)
        if receipe is None:
            return Response({'error': 'Receipe not found'}, status=status.HTTP_404_NOT_FOUND)

        # Increment popularity only if the user making the request is not the owner of the recipe
        if request.user != receipe.receipe_user_id:
            receipe.popularity += 1
            receipe.save()

        serializer = self.serializer_class(receipe)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def put(self, request, uuid_check, format=None):
        receipe = self.get_object(uuid_check)
        # user = request.data['user']
        
        if receipe is None:
            return Response({'error': 'Receipe not found'}, status=status.HTTP_404_NOT_FOUND)
        print(request.data)
        
        serializer = self.serializer_class(receipe, data=request.data)

        print("all ok")
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    def post(self, request, format=None):
        try:
            data = request.data.copy() 
     
            data['receipe_user_id'] = request.user.id 
            print(request.user.id)
          

            serializer = ReceipeSerializer1(data=data)  # Use the correct serializer
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                print("Serializer errors:", serializer.errors)
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            print("An error occurred:", e)
            return Response({"error": "An error occurred"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    def delete(self, request, uuid_check, format=None):
        receipe = self.get_object(uuid_check)
        
        if not receipe:
            return Response({"message": "Recipe not found."}, status=status.HTTP_404_NOT_FOUND)

        # Check if the authenticated user is the owner of the recipe
        if not request.user == receipe.receipe_user_id:  # Modify 'user' to the actual owner field of your Receipe model
            return Response({"message": "You don't have permission to delete this recipe."},
                            status=status.HTTP_403_FORBIDDEN)

        receipe.delete()
        return Response({"message": "Recipe deleted successfully."}, status=status.HTTP_204_NO_CONTENT)

    


class UserlistReceipe(APIView):
    permission_classes=[IsAuthenticated,IsOwner]
    serializers_class=ReceipeItemForUserSerializer
    def get(self,request,format=None):
        data=Receipe.objects.all()

        serializer=self.serializers_class(data,many=True)
        seralized_data=serializer.data
        return Response(seralized_data,status=status.HTTP_200_OK)
    
class FollowRelationView(APIView):
    permission_classes = [IsAuthenticated, IsOwner]
    serializer_class = FollowRelationSerializer
    
    def get(self, request, format=None):
        followee_users = request.query_params.get('user')
        followee_user=Account.objects.get(username=followee_users).id
        
        print()

    
        print(followee_user)
        follower_user = request.user.id


        try:
            follow_relation = FollowRelation.objects.get(user=followee_user, follower=follower_user)
            return Response({'followed': True}, status=status.HTTP_200_OK)
        except FollowRelation.DoesNotExist:
            return Response({'followed': False}, status=status.HTTP_200_OK)
    
    def post(self, request, format=None):
        data = request.data.copy()  
        data['follower'] = request.user.id 
        user = request.data['user']
   
        userid_queryset = User.objects.filter(username=user)
        
        if userid_queryset.exists():
            userid = userid_queryset.first().id  
            data['user'] = userid
        else:
            return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.serializer_class(data=data)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    def delete(self, request, format=None):
        follower_username = request.data.get('follower')  # Retrieve 'follower' username from the request body
        follower = request.user
        
        try:
            user_to_unfollow = User.objects.get(username=follower_username)
            follow_relation = FollowRelation.objects.get(user=user_to_unfollow, follower=follower)
            follow_relation.delete()
            return Response({"detail": "Follow relation deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except User.DoesNotExist:
            return Response({"detail": "User to unfollow not found."}, status=status.HTTP_404_NOT_FOUND)
        except FollowRelation.DoesNotExist:
            return Response({"detail": "Follow relation not found."}, status=status.HTTP_404_NOT_FOUND)
       
class UserdetailReceipe(APIView):
    permission_classes = [IsAuthenticated, IsOwner]
    serializers_class=UserSerializerforprofile
    def get(self, request, format=None):
        user = request.user
        profile=Account.objects.filter(username=user)
        print(profile)
        serializer=self.serializers_class(profile,many=True)
        seralized_data=serializer.data
        return Response(seralized_data,status=status.HTTP_200_OK)

class WishlistView(APIView):
    permission_classes = [IsAuthenticated, IsOwner]
    serializers_class=ReceipeItemSerializer
    
    def get(self, request, format=None):
        user = request.user
        receipes = Wishlist.objects.filter(user=user).values('recipe_id')
        uuid_list = [str(item['recipe_id']) for item in receipes]
        wishlist = Receipe.objects.filter(receipe_id__in=uuid_list)
        serializer=self.serializers_class(wishlist,many=True)
        seralized_data=serializer.data
        return Response(seralized_data,status=status.HTTP_200_OK)
    
    def delete(self, request, uuid, format=None):
        user = request.user
        print(user)
        try:
            wishlist_item = Wishlist.objects.get(user=user, recipe_id=uuid)
            print(wishlist_item)
        except Wishlist.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        wishlist_item.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)
    

    def post(self, request, format=None):
        username = request.user
        receipe_id = request.data['uuid']

        # Get the Receipe instance using the provided UUID
        recipe = get_object_or_404(Receipe, receipe_id=receipe_id)

        # Check if the recipe is already in the user's wishlist
        wishlist_item_check = Wishlist.objects.filter(user=username, recipe=recipe)

        if wishlist_item_check.exists():
            return Response({'detail': 'Recipe already exists in your wishlist'}, status=status.HTTP_200_OK)
        
        # If not, create a new Wishlist object and add it to the user's wishlist
        Wishlist.objects.create(user=username, recipe=recipe)

        return Response({'detail': 'Wishlist added'}, status=status.HTTP_200_OK)