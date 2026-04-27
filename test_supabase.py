import urllib.request
import json

url = 'https://erbidxbhooavcynttbml.supabase.co/rest/v1/products?select=*'
headers = {
    'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyYmlkeGJob29hdmN5bnR0Ym1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxODk5MTgsImV4cCI6MjA5Mjc2NTkxOH0.HyksCx9ZVhZNdXfgNLiH3V9HnZUDh8I3KFbM_ovUn8o',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyYmlkeGJob29hdmN5bnR0Ym1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxODk5MTgsImV4cCI6MjA5Mjc2NTkxOH0.HyksCx9ZVhZNdXfgNLiH3V9HnZUDh8I3KFbM_ovUn8o'
}

req = urllib.request.Request(url, headers=headers)
try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        print(f"Products count: {len(data)}")
except Exception as e:
    print(f"Error: {e}")

url = 'https://erbidxbhooavcynttbml.supabase.co/rest/v1/hero_images?select=*'
req = urllib.request.Request(url, headers=headers)
try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        print(f"Hero images count: {len(data)}")
except Exception as e:
    print(f"Error: {e}")
