from django.shortcuts import render
from port_lucas import data

def home(request):
    text = {
        'posts': data.posts
    }
    return render(request, 'port_lucas/index.html', text)