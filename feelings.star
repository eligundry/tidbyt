load("cache.star", "cache")
load("encoding/base64.star", "base64")
load("encoding/json.star", "json")
load("http.star", "http")
load("render.star", "render")
load("time.star", "time")

FEELING_EMOJIS = {
    'awful': base64.decode("iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAqNJREFUSEu9VltrE0EU/iY3qIJiWhWESm1UKErBvFgELVbjJYl9qb+gD16QKFYqBkSKCBGLFQ3i5aG/wL60SdRWW6Ig9SVCUQRt2mJAUNsEhVjIdndkZzab2d2kKUiyL7tnzznfNzPfOTNDUOWhqeB9HkJDAIgQTgESVW3ijV1aDUZMMsTRD/5hUDQBZK/m2FEGaF4bwEcQLJJ9id5yZJVJUv5vAGmuNtOSn2aIN7F9TSQ0FaBrBy4fSbxxw+ANRjmCpVyeITVuWm9B/JXlvs1uq08kqh+JJvJRswYjsRmMT2XYaJ/cDVhmcvZKnP07drgZPcF2k59mQPBKLQY2E5ryjwLklPo9PvWFBY/EvsJmI3g06K8q0fn+BBSFoie4SyPdreXQMeJNdBPeB1QlYCUam/jMAgK+NkNTVGNSqyWu5QZ9bcXweYCM1YskoIidXFxndSgOB/AgcpKNym6zWSYjK2oqcDH8HCsrJbdJP0pW64tCQUYo/IJlu5xA9HZJ/NC1OAoSB45GTsDlsldcUQuJJMks+OXkHGRZQXJ6jtmeFjcu9O7XgR4Ov0d6Icvszo5W2O02HO9qZbbTaSS0kPxdLrDAy9cn2HvrFgcHOuDBkYM7dZLXb2eRfJdm9o+ffK3u3fKx97oGl2FWKomuye8/y+gfmGQBT4esfVFxPTTHmT7eN4MDXdi4oaEYrmpiLGEzEAXfyiRJgUtYhoIkw+nkxUAqF3v5Eq4JiQoqdryZRCxpsTQr/Tfmax3PSPgBZdi70gtLuBOdxuluLnb7nm24EXmjY9wMH8LMp+/MfjY6i6uhDnhaGgUO096lK2Q6S7K5PNzCFj/0OKmD9J3r1L8Xc3k0mY6CNW/1NSHh+tT4ZBRFo7U843V96nFbKRXD/9+7/gEfDC5C49ox7wAAAABJRU5ErkJggg=="),
    'bad': base64.decode("iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAABDlJREFUSEu9Vk1oXFUU/s77mTc/mcmkSRtLQo2QCE0YN9l0IaaCiEQTrVqEQhGrokVjcSNSTUsbWsRFpY5SRS2oIJQ0WBINujIRF12oC2NTMRWjNjbpT5rMZN7M+z1y751MfrQ1usiFB+9779z7nXu+c869hP8wPnxk9g7AkzMeH6j/Ya1T6WaGHz82d7oqXhURNhFTB+mcqtiHlHPcQMIFe8HdfSr96I3W+jcSOxFPxBSJAcNYWiYIAMf15YeCXSjuPpWOr5nkox1/bhXGVena8UTcRNRSUw0T0LSlZcIQ8FXkUHIEkYf5XF7OfWKg7qflhCt2cnLnb6216Y3nhEEqKQgIpqnM4zEdQRBW5uq6BruowuV5goiRyyvWa3NX2vb03zq+aLz+JIPPTHMqlZAOxCwDpqHhzSNfS0wgvHR4e2Unrx8YAYMlfuHVu+B5IYqO0iiXK6D73VsqG5AvZ54e6QdRZ7qmKf7zd7Y0nBorIjSA5rZNEre116B6g0w0OeZnXZz7fk6+//LjDMgHGjIyR3B7exzz1ydtMA8/+N72nZLkm97PBwHusmIN6DjysDRMRqvx1csjMHSltq7pIFqKLjMjCJUmfsC4+7UO5Es5iUdfGYBTnBL7H7qz7/7u9SM5/9bxQQa6NLMRurVResPxJLY9twe+50h89ugZJGNJFSsC8nYe2/Y/JKFhWjj79kmQvSBx4FxG6F0UZkNbn9/XTX8cuyej1zdlQVoHRxoATZFcmtVx34EPEI2rhT3Xxtg72bIiQObZHpgRVX8lO48vDj+JzRtU+BBeAblTAIejwcxkD00fy2SMxuYsNK2Drc3IDqlcN60EwkgJpqGqMQwZezs7KyQnhoehaUojz3eguVF4TkHini4T5FwSk0b9mQs9tJBtzPCW27LQ9I7Q2oSWp36Xhi1NdfjsjR3QQiU8kQUOCOWsBUSLYRXKUAvwwIufYmLyqsQT72+B5lwGwmCUpn/tka54Qy1SE07UgKP10pApAhgpwCjrYCQAKpe/XNkDApXuCPKAnwOxqxwqzoAKs1ITs2tCZVf4SVqSoK4GHFG5jkgcbMQAUxVnc/uXEP1qcYg+duHbexX0bZBfBFxFSm4RuHpdkmi75taRhI9TP4M6qTEV51hUeWdZgBkBR2slzId1fyvGpKY0oNI11ZJFO5bhKoIv5mwCD9M+VhW/OPiEwagu9/aoCVgmKoeIoa/q9Qz4qlfB8wFXkJR7/7wD2uuv7F0VkqNoRZUuWz2qdMBctrBoL/oyn0JBUhZJiOUFQKFcJ/mgjfbjn1s9rweJ2AD3QZ5uiNA4ErTkvSi8cvHJ/2In4hEjYKDAgMutUpNenF8uw03PeD4EGwZUTosSWU1SlgA+inQQaz/jVyTCIZyGAXWICBKipdsKc658OwJ8uHQQ/++2spxQhrIXmcVv1Iex1f9vhP8Cg0Potr8//ggAAAAASUVORK5CYII="),
    'meh': base64.decode("iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAkdJREFUSEvFlctrE1EUxr+jHdNEaslGaRWfxTYRRKxduJDoSogmqdG1+OjKUoui4n+gaFEQFEFB0F0UGidWKAilC4WAICr2YaUWRPBBQBQnLZPOkdzbTDJtkjtRae9m5pz73fM7352ZO4RFGFSNwcltR7CMjyr7IL5HkdH+SjoV5CLIuqSG0HmKjvS5hnBit1eIPT8MZfH5glVZsZb2TU2XTjmccKrdB8v4XXPxMrBS0BJAHgfYbqoxCIQeATMZmRrcs9Dg/ucy5/EDQzHg14StodiobUDccH/bYRC1gHAZdQ1SGE4jtHW7vejBoI71b8N2PNmm4/jBuB0Pv38DPN0l45wBsNUL0EfqHEtJiB7UwRwRggMvxSW+N4LM1++O7of7cnm1yIXOaY65NWubkXg29xYPtMs5ohRFR6JLBOm4KZpIT2i40HXK7nZ1cxMenv1kx/ErTch8Kzq9fv8udrZYcv7FCYWTQpnoOzAD09msyHhfdQOZdHGLNh+DsalbxD7fSiC/J3rQsYWVt6sga5UFcqYprnVfBgDjc7GIfwdMf4eINW2FzI/LXbBHxWfilP1b5BpS9XSb66H4ddXu5PUk4fSt5Uo3t3tmEdhQhuTGyf+FJAOHANoC4qvKtl0LuAezmKL42BPnAVl6drkuVl644OwqyDixzgtPQ+3/kfkczayn8IeZQtrpZDEgeTIPbawXHfz0yk+9lqGZYm2pCxFXq8HJwBkQrik5bPVS5/iNSrrqED0YA3BSCbGsO/n/xl9BlMVdCv4Acd/7GqxiiIUAAAAASUVORK5CYII="),
    'good': base64.decode("iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAmpJREFUSEvFlk9oE0EUxr83BkMTjYgSclEQe2jSooKoRYWiVlAw22i1CoIVFKUKIgqi4qmCqAcP4h9QEKmXglKbjXqQWixEEaEoxSR60SItSBWlSU2skozsTLLNpmR3U7Gdy+bb9837zXuzPEKYhkVmDN7t3w1Gey3PkaMOCsUelPOZQ8L+cwDOW0I4O0Oh2EXbEN6xzC3M8/6MWSYvNTCX2EvB/nRxyFCJABSS+xqB1VcBnpX+SJ22vWgvB4LvpKZZwKsjwMhzqcdTLmoZyhTMMwAJ+zl8m8QBMnWXsWXFGv3k+44exoEl13V988NBdN6+q+unA6/hfHNM6q9RUFNCL0D84F2BXSBUg/ELUOLCp9Q3YPT7D0PX+64tBJgDIAca2oYMsQVeL7qiPfKdGgA4ToDRR1LiYQlRAyo4DwpDcEA8Usk0tq1aryfaujOE0/X38/dCaO9T8CzyWI8/6X8Jt9sp9aPl8kkUISWuzBAEXJ5CSQAjUcC9SGr3YkCtnWiR1taxQanTw4B3HaD68/H8dZStxNDpfxRWkN/zWzHbO8c2ZfxLEs7Re0a/FSS1tBdza322Icm3w/B83lwZpOfQHtuAgrHxVmdlkBdng8h8k2PMznL5UljbPvFJm3/C+Yz/AVLTDFA1OAzjupKWTWpVDseRY5+oOaYaB6Q2u0pWb1uLeJPLskldYw45oTfe0CZByXWUzq5CmEdWupBL/7RzB6YeT6aKNgz+KniMlUwHRCOLakR/plCRJ1OlbS2uQmizsvlD/ykwXLJuHz9JTe+vlPNZ/JGo2QFi+y0hWX6Htie6pwSxTG7T8BcJeBUp0bZ8jAAAAABJRU5ErkJggg=="),
    'rad': base64.decode("iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAA0FJREFUSEu9lmtIVEEUx/9z3XTXIkHxASqIRQ8DSS37UlS2PZDWVbIwQ5JIy8eXROxLkuZmUSJIhVaURR/cQBJXMB+pvSGCKCx3E5QC+2CpHwTXNffeiZnrXb3rqmuUB5a9Z+bM/M6cMzNnCFZAyAyDUFCcKf6WOBwRxZvyr1TAnJuLsaBQl84+ovb0OzZkvnfA+LWfANTlo3nMgozAFE8+cwgFJeUoJ8Mlpw7/iIzkdoUmE8x5ORiZgTCdSfhe20RM5ocJpFjfqSANoxTHgxSnVSzeWJfUaKGAoS3tCAoqK7hBX3wCeg4lo/CyrINSJNU+BhEoiPtUlNhJat/qhSLPzY03qQUUBgboTdzBbV/qD8gAKkdkX50MWEyI0crnmxSqqU4qcrmycpD2cBMPl21rHA8Rk4JKE4gkQX/H7N3+cwqYOpcuR3YoQNJJRT7KQL6SmuRWCyXU4J4DrwHKbKIgf/lIDmK06lQQJSdzc8AAKRc1SkrQcsk5b0XJpRretsoHaC5T9yv5Yf2qnPxXSEeYyQJCDXNzsLtYg6C1FDpfeQFDIwQvqma9Zf0RwfJum5wCRscJsq8e5HqsMICEtCYeO3aW+EqehZXzxOtvzyY5qUSD7muzky6lE/trXPet5ZA2cRu6xO0AIS3sFuCQwdNHOSTa8NkV94edAk7ul7zWGeSVNp/bNzqTUONMV0OoJcYCSg3e7VXPVsT+Bk7/Xbyz3pmCnN/Ffw950CGgvkPeqnNzxFaiyBddFrZMPloawgZR/53z3JYoIEqA/rwG7VXqS0yEDF9j7wYg5oHQ78gIeSrfwh7C9e8hzTEnALoRQKniugQCYU65UNpZqNiPeTdquqdaqRbTXH+rPQs/Y6/6glQsafPmxa9ZAJ8GCD4OEtxvF1Q5UdEkoidpfV1KmyqotDUuGNOOn6xT7NwEEj0KYd0v1fiGHgENzwWUZYmIX+/uExX5ATTa5PtmRlYewjfBk9gQ9u9Izx7WNt1dztEZJ0ZrgKcB82oyq2rMUCtpA9F0owgCLixMonIsjbZQXu9ZnWfiVuvnQRyk2sLs/KhfJppupcIHxxaESNI470u1ZXEIe7EwcXu1eHxdLCdG3tj+AQnrlCkLmzOrAAAAAElFTkSuQmCC"),
}

def main(config):
    latest_feeling = cache.get("latest_feeling")

    if latest_feeling == None:
        resp = http.get("https://api.eligundry.com/api/feelings")

        if resp.status_code != 200:
            fail("Could not load data from API (status: %d)", resp.status_code)

        latest_feeling = resp.json()[0]
        cache.set("latest_feeling", json.encode(latest_feeling), ttl_seconds=60 * 60 * 60)

    else:
        latest_feeling = json.decode(latest_feeling)

    mood = latest_feeling['mood']
    post_time = time.parse_time(latest_feeling['time']).format("01-02")


    # If you want to demo all the moods, uncomment this
    # demo = []
    #
    # for demo_mood in FEELING_EMOJIS.keys():
    #     box = render.Box(
    #         render.Row(
    #             expanded = True,
    #             main_align = "space_evenly",
    #             cross_align = "center",
    #             children = [
    #                 render.Image(src=FEELING_EMOJIS[demo_mood]),
    #                 render.Column(
    #                     expanded = True,
    #                     main_align = "space_evenly",
    #                     children = [
    #                         render.Text(demo_mood),
    #                         render.Text(content=post_time, font='CG-pixel-3x5-mono'),
    #                     ]
    #                 )
    #             ]
    #         )
    #     )

    #     for _ in range(0, 10):
    #         demo.append(box)

    # return render.Root(
    #     child = render.Animation(demo)
    # )

    return render.Root(
        child = render.Box(
            render.Row(
                expanded = True,
                main_align = "space_evenly",
                cross_align = "center",
                children = [
                    # render.Image(src=FEELING_EMOJIS[mood]),
                    render.Image(src=FEELING_EMOJIS['awful']),
                    render.Column(
                        expanded = True,
                        main_align = "space_evenly",
                        children = [
                            render.Text(mood),
                            render.Text(content=post_time, font='CG-pixel-3x5-mono'),
                        ]
                    )
                ]
            )
        )
    )
