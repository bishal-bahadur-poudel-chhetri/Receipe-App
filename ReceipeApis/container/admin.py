from django.contrib import admin
from accounts.models import Account
from container.models import  Banner, Procedure, Receipe,ReceipeCategory,ReceipeIngredient,Ingredient,Unit,Review,FollowRelation, Wishlist
admin.site.register(Receipe)

admin.site.register(ReceipeCategory)
admin.site.register(ReceipeIngredient)
admin.site.register(Ingredient)
admin.site.register(Unit)
admin.site.register(Review)
admin.site.register(Procedure)
admin.site.register(FollowRelation)
admin.site.register(Account)
admin.site.register(Wishlist)
admin.site.register(Banner)



