load("cache.star", "cache")
load("encoding/base64.star", "base64")
load("html.star", "html")
load("http.star", "http")
load("random.star", "random")
load("re.star", "re")
load("render.star", "render")

AVATAR = base64.decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAYxJREFUKFMdysFLU3EAwPHv7723ZA30KYkdkmGISB1GDomWFnXdH9AtpEPgqaMHL+JuSVCe9JKRSHXpoEIzKMyx4daYkduYiRv6nJu+epZvk83n9gv8nD8i+sOSLTic2mm83m50KwJmhfT+P95FDR4/fYbW0YlIpEqymM8RDPpwiTNOEmHqtkkyvs2vrTLzxSJPHo0ivkZTUtrH9HZfwanV0T2SXDaJmT5gNbNJOPadq14vYi2+Ib8tfqS8t8NuvsDQ8CDRL5+wpILiNChZNpc7dMRqPCabToXl2TkuuT0M+P0svX3D4d8/VJsqpZNjem70IZ7PLEjftU72UksEhu4TWYnR/F2mVW/h83qe8lmFgcADxMTUBznY14p2mERv19ncMMhnc3jazvmZsXB1teO7fQ8Rerkgu9QqI8GbuFSNybEX1GigCIVwPMGtwEP8d4YRoVevpds+5W6/wnpkjULWvIiGYWBqHsZDk9TRENMz76VSk1x3Z1heXKGwY9FwqaiqytF5g+nZOapNh//JUbRU613cTwAAAABJRU5ErkJggg==")

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
    # remove urls from tweets as i cannot click them
    selected_tweet = re.sub(r'http\S+', '', selected_tweet)


    return render.Root(
        child = render.Marquee(
            height = 32,
            scroll_direction = 'vertical',
            child = render.Column(
                children = [
                    render.Row(
                        expanded = True,
                        cross_align = "center",
                        children = [
                            render.Image(src = AVATAR),
                            render.Text(" @dril", color = "#099"),
                        ]
                    ),
                    render.WrappedText(selected_tweet),
                ]
            )
        )
    )
