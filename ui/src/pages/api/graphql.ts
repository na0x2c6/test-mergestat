import type { NextApiRequest, NextApiResponse } from 'next'
import httpProxyMiddleware from 'next-http-proxy-middleware'

export const config = {
  api: {
    externalResolver: true,
  },
}

const proxy = (req: NextApiRequest, res: NextApiResponse) => {
  return httpProxyMiddleware(req, res, {
    target: process.env.POSTGRAPHILE_API,
    ignorePath: true,
    headers: {
      ...(req.cookies.jwt ? { authorization: `Bearer ${req.cookies.jwt}` } : null),
    }
  })
}

export default proxy
