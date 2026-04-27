import urllib.request
import json
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

url_base = 'https://erbidxbhooavcynttbml.supabase.co/rest/v1'
headers = {
    'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyYmlkeGJob29hdmN5bnR0Ym1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxODk5MTgsImV4cCI6MjA5Mjc2NTkxOH0.HyksCx9ZVhZNdXfgNLiH3V9HnZUDh8I3KFbM_ovUn8o',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyYmlkeGJob29hdmN5bnR0Ym1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxODk5MTgsImV4cCI6MjA5Mjc2NTkxOH0.HyksCx9ZVhZNdXfgNLiH3V9HnZUDh8I3KFbM_ovUn8o',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation'
}

# Seed Hero Images
hero_data = [
    { "images": [
        "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&q=80&w=1600",
        "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&q=80&w=1600",
        "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=1600"
    ]}
]

req = urllib.request.Request(f"{url_base}/hero_images", data=json.dumps(hero_data).encode('utf-8'), headers=headers, method='POST')
try:
    with urllib.request.urlopen(req, context=ctx) as response:
        print("Hero images seeded successfully.")
except Exception as e:
    print(f"Error seeding hero images: {e}")
    if hasattr(e, 'read'):
        print(e.read().decode())

# Seed Products
products_data = [
    {
        "name": "Classic White Tee",
        "price": 500,
        "stock": 50,
        "sizes": ["S", "M", "L", "XL"],
        "colors": [
            {
                "color": "#ffffff",
                "images": ["https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=500&q=60"]
            }
        ]
    },
    {
        "name": "Black Denim Jacket",
        "price": 1500,
        "stock": 20,
        "sizes": ["M", "L", "XL"],
        "colors": [
            {
                "color": "#000000",
                "images": ["https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=500&q=60"]
            }
        ]
    },
    {
        "name": "Urban Cargo Pants",
        "price": 1200,
        "stock": 30,
        "sizes": ["30", "32", "34", "36"],
        "colors": [
            {
                "color": "#556b2f",
                "images": ["https://images.unsplash.com/photo-1517438322307-e67111335449?auto=format&fit=crop&w=500&q=60"]
            }
        ]
    },
    {
        "name": "Minimalist Sneakers",
        "price": 2000,
        "stock": 15,
        "sizes": ["40", "42", "44", "45"],
        "colors": [
            {
                "color": "#eeeeee",
                "images": ["https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=500&q=60"]
            }
        ]
    },
    {
        "name": "Vintage Oversized Hoodie",
        "price": 1800,
        "old_price": 2200,
        "stock": 40,
        "sizes": ["S", "M", "L"],
        "colors": [
            {
                "color": "#8b0000",
                "images": ["https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=500&q=60"]
            }
        ]
    },
    {
        "name": "Graphic Print T-Shirt",
        "price": 600,
        "stock": 100,
        "sizes": ["S", "M", "L", "XL", "XXL"],
        "colors": [
            {
                "color": "#111111",
                "images": ["https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=500&q=60"]
            }
        ]
    }
]

req = urllib.request.Request(f"{url_base}/products", data=json.dumps(products_data).encode('utf-8'), headers=headers, method='POST')
try:
    with urllib.request.urlopen(req, context=ctx) as response:
        print("Products seeded successfully.")
except Exception as e:
    print(f"Error seeding products: {e}")
    if hasattr(e, 'read'):
        print(e.read().decode())
