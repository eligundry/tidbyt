import axios from 'axios'

const deviceID = process.env.DEVICE_ID
const apiToken = process.env.API_TOKEN
const userAgent = 'Eli Gundry <https://github.com/eligundry/tidbyt>'

if (!deviceID) {
  throw new Error(`DEVICE_ID env var must be set`)
}

if (!apiToken) {
  throw new Error(`API_TOKEN env var must be set`)
}

const widgets = {
  Feelings:
    'https://raw.githubusercontent.com/eligundry/tidbyt/main/feelings.star',
  Dril: 'https://raw.githubusercontent.com/eligundry/tidbyt/main/dril.star',
}

const log = (
  level: 'log' | 'info' | 'warning' | 'error',
  msg: string,
  data: any
) =>
  console[level](
    JSON.stringify({
      level,
      ts: new Date().toISOString(),
      msg,
      data,
    })
  )

const generateWidget = async (widgetURL: string): Promise<string> =>
  axios
    .get<string>('https://axilla.netlify.app/', {
      responseType: 'text',
      params: {
        applet: widgetURL,
        output: 'base64',
      },
      headers: {
        'user-agent': userAgent,
      },
    })
    .then((resp) => resp.data)

const uploadWidget = async (name: string, image: string) =>
  axios.post(
    `https://api.tidbyt.com/v0/devices/${deviceID}/push`,
    {
      deviceID,
      installationID: name,
      background: true,
      image,
    },
    {
      headers: {
        authorization: `Bearer ${apiToken}`,
        'content-type': 'application/json',
        'user-agent': userAgent,
      },
    }
  )

export const tidbyt = async () => {
  const successful: string[] = []
  const failed: Record<string, unknown> = {}

  await Promise.all(
    Object.entries(widgets).map(async ([name, widgetURL]) => {
      log('info', 'generating image', { name })
      const image = await generateWidget(widgetURL)
      log('info', 'generated image', { name })
      log('info', 'uploading image to tidbyt', { name })

      try {
        const resp = await uploadWidget(name, image)
        log('info', 'successfully uploaded image to tidbyt', {
          name,
          response: resp.data,
        })
        successful.push(name)
      } catch (e) {
        if (e.response) {
          failed[name] = e.response.data
        } else {
          failed[name] = e.message
        }

        log('error', 'failed to upload image to tidbyt', {
          name,
          response: failed[name],
        })
      }
    })
  )

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        successful,
        failed,
      },
      null,
      2
    ),
  }
}

tidbyt()
