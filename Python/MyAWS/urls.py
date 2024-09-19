"""
URL configuration for MyAWS project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.port_lucas, name='port_lucas')
Class-based views
    1. Add an import:  from other_app.views import port_lucas
    2. Add a URL to urlpatterns:  path('', port_lucas.as_view(), name='port_lucas')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from port_lucas import views as port_lucas_views

urlpatterns = [
    path('', port_lucas_views.home, name='home'),
    path('admin/', admin.site.urls),
    
]
