from django.contrib import admin
from django.urls import path,include
from container.views import *
from django.conf.urls.static import static
from recipe import settings






urlpatterns = [

    path('',include('accounts.urls')),
    path('api/receipe/',checklistapi.as_view()),
    path('api/userlist/',UserlistReceipe.as_view()),
    path('api/userdetail/',UserdetailReceipe.as_view()),
    path('api/categories/',categorylist.as_view()),
    path('api/receipedetail/<uuid:uuid_check>',CategoryListDetail.as_view()),
    path('api/receipedetail/',CategoryListDetail.as_view()),
    path('api/follow/',FollowRelationView.as_view()),
    path('api/wishlist/',WishlistView.as_view()),
    path('api/wishlist/<uuid:uuid>/', WishlistView.as_view(), name='wishlist-detail'),
    
 







    
    


]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)