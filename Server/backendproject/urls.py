from django.contrib import admin
from django.urls import path, include
from backendproject import views
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('accounts.urls')),    #path to user-related APIs
    path('check/<url>', views.CheckIngredient)
]

urlpatterns = format_suffix_patterns(urlpatterns)