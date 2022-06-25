load("render.star", "render")
load("http.star", "http")

FEELING_EMOJIS = {
    'awful': '',
    'bad': '',
    'meh': '',
    'good': '',
    'rad': '',
}

def main():
    resp = http.get("https://api.eligundry.com/api/feelings")

    if resp.status_code != 200:
        fail("Could not load data from API (status: %d)", resp.status_code)

    latest_feeling = resp.json()[0]

    return render.Root(
        render.Text("I felt %s" % latest_feeling['mood'])
    )
