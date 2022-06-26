load("cache.star", "cache")
load("http.star", "http")
load("html.star", "html")
load("render.star", "render")
load("random.star", "random")

def main():
    """
    Show a random @dril tweet on each render on the Tidbyt
    """
    dril_raw_html = cache.get('dril_raw_html')

    if dril_raw_html == None:
        resp = http.get('https://cooltweets.herokuapp.com/dril/old')

        if resp.status_code != 200:
            fail("Could not load dril tweets (status: %d)", resp.status_code)

        dril_raw_html = resp.body()
        cache.set('dril_raw_html', dril_raw_html, ttl_seconds=60 * 60 * 24)

    dril_html = html(dril_raw_html)
    tweets = dril_html.find('li.t > .text')
    selected_tweet = tweets.eq(random.number(0, tweets.len())).text()

    return render.Root(
        child = render.Marquee(
            height = 32,
            child = render.WrappedText(selected_tweet),
            scroll_direction = 'vertical'
        )
    )
