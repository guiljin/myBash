import requests

proxies = {
    "http": "http://10.144.1.10:8080",
    "https": "https://10.144.1.10:8080"
}
r = requests.post("http://httpbin.org/post", proxies=proxies)
print r.text
