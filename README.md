# Elixir Exporter

# TODO
- Refactor to use modules or multi-target pattern for collectors to allow multiple instances of each
- Figure out how to attach with `iex` in the docker container
- Disable/enable collectors using config file
    - Adding own collectors through folder and load them on startup?
- More scalable way to give config options. What's the Usual Elixir method?

# Usage

## Configuration
Currently, there are 4 configuration options, all of which are given through environment variables:

- PLEX_URL: root url of the plex server. Api route will be appended to it
- JELLYFIN_URL: same as above
- PLEX_TOKEN: Plex API token, see how to find it [here](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/)
- JELLYFIN_TOKEN: Jellyfin API key. Create by going to dashboard -> API Keys

## Running
See `compose/` for an example of how to run the program. For building and development, see the makefile targets.
