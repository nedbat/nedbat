# First, do this:
#   gist -p README.md
# then take the id produced, and run:
#   echo README.md | entr ./push_to_gist.sh abc123etc456

python -m cogapp -rP README.md
gist -u $1 README.md
