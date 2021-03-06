nock = require('nock')

cassettes =
  '/account valid':
    host: 'https://api.heroku.com'
    path: '/account'
    code: 200
    body:
      id: "01234567-89ab-cdef-0123-456789abcdef",
      allow_tracking: true,
      beta: false,
      created_at: "2012-01-01T12:00:00Z",
      email: "username@example.com",
      last_login: "2012-01-01T12:00:00Z",
      name: "Tina Edmonds",
      two_factor_authentication: false,
      updated_at: "2012-01-01T12:00:00Z",
      verified: false,
      default_organization:
        id: "01234567-89ab-cdef-0123-456789abcdef"
        name: "example"
  '/account invalid':
    host: 'https://api.heroku.com:443'
    path: '/account'
    code: 401
    body:
      id: "unauthorized"
      error: "There were no credentials in your `Authorization` header. Try `Authorization: Bearer <OAuth access token>` or `Authorization: Basic <base64-encoded email + \":\" + password>`."

nock.disableNetConnect()

module.exports.get = (vcrName) ->
  cassettes[vcrName]

module.exports.play = (vcrName) ->
  cassette = cassettes[vcrName]
  path = vcrName
  method = cassette.method || 'get'
  if cassette.path
    path = cassette.path
  nock(cassette.host).filteringPath(/\?.*/g, '')[method](path)
    .reply(cassette.code, cassette.body)

module.exports.stop = ->
  nock.cleanAll()

module.exports.playback = ->
  nock.disableNetConnect()
