from django.urls import path
from knox import views as knox_views
from django.conf import settings
from django.conf.urls.static import static
from . import views

#/api/
urlpatterns = [
    path('get_user/<url>/', views.get_user),          #specific user default data API
    path('all_users/', views.all_users),              #all users' default data API
    path('login/', views.login),                      #login API
    path('register/', views.register),                #register API
    path('info_list/', views.info_list),              #GET all users' profile info & POST new user profile info
    path('info_specific/<url>/', views.info_specific),#GET specific username's profile info & PUT(edit) specific username's profile info data
    path('upload_image/<url>/', views.upload_image),  #Upload profile picture API
    path('logout/', knox_views.LogoutView.as_view(), name='knox_logout'),
    path('logoutall/', knox_views.LogoutAllView.as_view(), name='knox_logoutall'),
]
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)