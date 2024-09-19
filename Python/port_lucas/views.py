from django.shortcuts import render
from port_lucas import data

def home(request):
    context = {
        'posts': data.posts
    }
    return render(request, 'port_lucas/index.html', context)