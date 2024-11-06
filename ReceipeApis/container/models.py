from django.db import models
import uuid,random
import os
from django.contrib.auth import get_user_model
User=get_user_model()

class BaseModel(models.Model):
    update_at=models.DateField(auto_now=True)
    created_at=models.DateField(auto_now=True)
    class Meta:
        abstract=True

class ReceipeCategory(models.Model):
    category_id=models.AutoField(primary_key=True)
    category_name=models.TextField(max_length=15)
    def __str__(self):
        return self.category_name

# Create your models here.
class Receipe(models.Model):
    receipe_id=models.UUIDField(primary_key=True, default=uuid.uuid4,editable=False)
    receipe_title=models.CharField(max_length=15)
    receipe_user_id=models.ForeignKey(User,on_delete=models.CASCADE)
    category_id=models.ForeignKey(ReceipeCategory,on_delete=models.CASCADE,related_name="receipe_category")
    Description=models.TextField()
    Prep_time=models.DecimalField(max_digits=5,decimal_places=1)
    cook_time=models.DecimalField(max_digits=5,decimal_places=1)
    serving_quantity=models.IntegerField(2)
    categoryImage=models.ImageField(null=True, blank=True)
    popularity = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.receipe_title
    
class Ingredient(models.Model):

    ingredient_id=models.AutoField(primary_key=True)
    ingredient_name=models.CharField(max_length=15)
    ingredient_url = models.ImageField(upload_to='ingredient_images/', null=True, default='path/to/default/image.jpg')
    def __str__(self):
        return self.ingredient_name
    
class Unit(models.Model):
    unit_id=models.AutoField(primary_key=True)
    unit_name=models.CharField(max_length=20)
    def __str__(self):
        return self.unit_name    


class ReceipeIngredient(models.Model):
    receipe_id = models.ForeignKey(Receipe, on_delete=models.CASCADE,related_name="ingredient_receipe")
    ingredient_id = models.ForeignKey(Ingredient, on_delete=models.CASCADE,related_name="ingredient_detail")
    amount = models.IntegerField(default=10)
    unit = models.ForeignKey(Unit, on_delete=models.CASCADE, related_name="receipe_unit")

    def __str__(self):
        return self.ingredient_id.ingredient_name


    
class Review(BaseModel):
    review_id=models.AutoField(primary_key=True)
    receipe_id=models.ForeignKey(Receipe,on_delete=models.CASCADE,related_name="review_identity")
    user_id=models.ForeignKey(User,on_delete=models.CASCADE)
    comment=models.CharField(max_length=30)

    def __str__(self):
        return self.unit_id
    
class Procedure(models.Model):
    procedure_id = models.AutoField(primary_key=True)
    receipe_id = models.ForeignKey(Receipe, on_delete=models.CASCADE, related_name="procedure_receipe")
    description = models.TextField()
    procedure_number = models.PositiveIntegerField()  # Add a new field to track the procedure number

    class Meta:
        unique_together = ('receipe_id', 'procedure_number')


class FollowRelation(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='following')
    follower = models.ForeignKey(User, on_delete=models.CASCADE, related_name='followers')

    def __str__(self):
        return f"{self.follower} follows {self.user}"
    

class Wishlist(models.Model):
    wishlist_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='wishlist_items')
    recipe = models.ForeignKey(Receipe, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.user}'s Wishlist"


class Banner(models.Model):
    def get_banner1_upload_path(self, filename):
        return f'banner/Banner1/banner1.jpg'

    def get_banner2_upload_path(self, filename):
        return f'banner/Banner2/banner2.jpg'

    def get_banner3_upload_path(self, filename):
        return f'banner/Banner3/banner3.jpg'

    Banner1 = models.ImageField(upload_to=get_banner1_upload_path, null=False)
    Banner2 = models.ImageField(upload_to=get_banner2_upload_path, null=False)
    Banner3 = models.ImageField(upload_to=get_banner3_upload_path, null=False)
