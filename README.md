# Black Hole Hunter

[Black Hole Hunter][bhh] is a browser based game where players search for
gravitational waves through sound, developed by
[Cardiff University Gravitational Physics Group][gravwaves].

## Installation

1. Install [Python](https://www.python.org/).
2. Install [Node.js](https://nodejs.org). We used the 18.13.0 release, which provides ` npm --version` of 8.6.0. It's possible that issues will exist in other versions, but hopefully this won't be too sensitive to version number.
3. `git clone https://gravity.astro.cf.ac.uk/git/black-hole-hunter/`
4. Run `npm install .` in the root directory of the cloned website.
5. Install `webpack` globally with `npm install -g webpack` and `npm install -g webpack-cli`

## Usage

1. Run `webpack` in the root directory of the cloned website.
1. Run `python -m http.server 8000` in the root directory of the cloned website.
2. Open a browser at `http://localhost:8000`.

## Acknowledgements

We thank Ian Harry, David McKechan and Gerald Davies for their incredible work creating the original Black Hole
Hunter.

## License

[Black Hole Hunter][bhh] is released under the [MIT license][license].

[bhh]: http://blackholehunter.org
[gravwaves]: http://www.astro.cardiff.ac.uk/research/gravity/
[license]: LICENSE.md
