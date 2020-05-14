import requests
import base64

image_stream = open(r"jfk.jpg", "r+b").read()
encoding = base64.b64encode(image_stream)

image_stream2 = open(r"jfk.jpg", "r+b").read()
encoding2 = base64.b64encode(image_stream2)

#print("here")
#requests.get('https://ene5faqz9buem.x.pipedream.net', data={'name': 'NihalPotdar'})
#print(requests.post('https://enmzf4e2nlb5.x.pipedream.net/', data={ 'name': 'Nihal Potdar' }).text)
print(requests.post('https://alzfaceapi.herokuapp.com/add_person', data={'name': 'Jfk', 'image_stream': encoding2}).text)

#print(requests.post('http://localhost:8080/identify_person', data={'image_stream': encoding}).text)
#print(requests.post('https://alzfaceapi.herokuapp.com/identify_person', data={'image_stream': encoding2}).text)