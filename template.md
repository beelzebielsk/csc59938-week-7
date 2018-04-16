# Project 7 - WordPress Pentesting

Time spent: **30** hours spent in total

> Objective: Find, analyze, recreate, and document **three vulnerabilities** affecting an old version of WordPress

## Pentesting Report

1. CVE-2015-3440
  - [ ] Summary: This is an unauthenticated XSS scripting attack. All
    the attacker needs is to post at least one approved comment on a
    site, so that later comments are automatically approved. The
    attacker bypasses WordPresses HTML filter on comments by posting a
    comment that is too large for WP's MySQL database to store fully.
    The original comment is valid, safe HTML, but the truncated
    version contains an XSS payload, by messing with quoting (an
    ending quotation mark is truncated).
    - Vulnerability types: XSS
    - Tested in version: 4.2
    - Fixed in version: 4.2.1
  - [ ] GIF Walkthrough: ![walkthrough](xss-1.gif)
  - [ ] Steps to recreate: 
    - Go to WP site.
    - Create a comment on a post (if you have not done so already).
    - Wait until the comment gets approved.
    - Craft the exploit. The general format is `<a title='
      onmouseover=eval(unescape(/{exploit code}/.source)) {optional
      styles} {64 KB of text}'/>`
    - The 64 KB of text are there because the WP database cannot store
      more than 64 KB of text. Anything after 64 KB of text is simply
      truncated, and the rest is stored.
    - After truncation, the ending `'/>` is removed. Now the HTML will
      be interpreted as `<a title="'" onmouseover={exploit} {styles}
      {64 KB of text}`. The event listener code that used to be
      contained within a very long quote now is not. The starting
      quotation mark becomes the attribute value of `title`.
    - Now, if a user triggers the event listener on your content,
      your exploit code runs.
1. CVE-2015-5622
  - [ ] Summary: An XSS attack which requires both authentication and
    the ability to post on a site.
    - Vulnerability types: XSS
    - Tested in version: 4.2
    - Fixed in version: 4.2.3
  - [ ] GIF Walkthrough: ![walkthrough](xss-2.gif)
  - [ ] Steps to recreate: 
    - Create an account on a WP site.
    - Get the ability to create posts on that site. This means getting
      an account type of **contributor**.
    - Create a post, then go to the page for editing the post.
    - Once there, you should see the WP editor. Above the area where
      you can type should be two tabs which say *visual* and *text*.
      Select **text**.
    - Insert the exploit HTML into the WP post editor. The general
      form of the exploit is: 
        <a href="[caption code=">]</a><a title=" onmouseover={exploit code} ">link</a> 
    - The `[caption code="` is the start of WordPress Shortcode. The
      given HTML is valid and safe, by itself. Wordpress Shortcode
      considers everything from `[catpion code="` to `title="` to be
      part of the Shortcode statement. The resulting HTML, after
      whatever Shortcode evaluator runs is:

        <a href="</a><a title=" onmouseover={exploit} ">link</a>

      The quotation in `title` ends up closing the quotation started
      after `href`. Now the event listener is bare.
  - [ ] Affected source code:
    - [Link 1](https://core.trac.wordpress.org/changeset/33359)
1. CVE-2016-6635
  - [ ] Summary: One of the things you can do with the WordPress AJAX
    handlers is to update a plugin. This should be privileged
    functionality, but part of what it does is done before any sort of
    validation of privilege checking is done. WP tries to read the
    contents of a file, and the filepath that it uses is directly
    provided by user input without any sort of sanitization. You can
    force the WP server to perform a blocking read on a file, thus
    stalling the server.  
    - Vulnerability types: DDOS
    - Tested in version: 4.2
    - Fixed in version: 4.5
  - [ ] GIF Walkthrough: ![walkthrough](ddos-1.gif)
  - [ ] Steps to recreate: 
    - Create an account on a WordPress site.
    - Fill out the parameters of `ddos-1/ddos-script.sh` (I will refer
      to this as *the script* for the rest of this explanation).
        - `target` : The WP site to attack.
        - `username` : The username of the account you created in the
          previous step.
        - `password` : The password of the account you created in the
    - Run the script. The script:
        - logs you in to the site, and writes your cookie down in a
          file for use on later requests.
        - Then it sends 1000 different requests to the site requesting
          the update of a plugin, specifying the plugin path as
          the `/dev/random` on the WP server.
            - NOTE: The path has `../` repeated over and over again.
              no matter where you are, you can just flood the start of
              the relative path with `../` so that you can be sure
              you've backed all the way up to the root directory. From
              there on out, the rest of your path is essentially an
              absolute path.  So the long path in the script is
              basically just `/dev/random`, where the initial `/` is
              replaced by a good number of `../` to try and ensure
              that we've reached the root directory. How often would
              someone put wordpress files something more than 10
              folders deep on a server (that's how many `..` are in
              the path). Probably not often, I guess. 
        - By servicing all of these requests, the server will exhaust
          the entropy of `/dev/random`. The `/dev/random` file is
          supposed to be a dependable source of random data, and thus
          when it runs out of entropy, rather than give
          not-very-random data, it will stop giving data altogether.
          Anyone reading `/dev/random` will have to wait for more
          data. This waiting is a *blocking read*. The computer just
          waits until it gets data, for as long as it needs to.
  - [ ] Affected source code:
    - [Link 1](https://github.com/WordPress/WordPress/commit/9b7a7754133c50b82bd9d976fb5b24094f658aab)
    - [Link 2](https://sumofpwn.nl/advisory/2016/path_traversal_vulnerability_in_wordpress_core_ajax_handlers.html)

## Assets

There are folders for each exploit. Each folder contains the assets
used for each exploit.

- `xss-1/xss.py` : This takes in code to execute and creates HTML that
  will execute the code by exploiting the vulnerability used with
  `xss-1`.
- `xss-2/xss.py` : This takes in code to execute and creates HTML that
  will execute the code by exploiting the vulnerability used with
  `xss-2`.
- `ddos-1/ddos-script.sh` : This script was obtained from one of my
  sources. It launches the DDOS attack on a server.

## Resources

- [WordPress Source Browser](https://core.trac.wordpress.org/browser/)
- [WordPress Developer Reference](https://developer.wordpress.org/reference/)

Videos created with [SimpleScreenRecorder](http://www.maartenbaert.be/simplescreenrecorder/), then converted to GIF using [ffmpeg](https://ffmpeg.org/)

## Notes

For xss-1 : It took me a while to correctly craft the exploit string.
It took me longer to craft an exploit string that would send a GET
request to a remote server that contained the user's cookies. I got
warnings that I couldn't concatenate strings together for some reason.
I ended up finding another way to concatenate the strings.

I went through more than 3 exploits, but I hit dead ends in most of
them. In truth, I spent most of my time chasing dead ends and almost
none of my time with the presented exploits.

- `CVE-2015-2213` : This was an SQL injection. The only resources I
  could identify on this exploit was the location of a `wpdb->query`
  statement that did not use `wpdb->prepare` to properly quote the
  user data placed into the query. There were no write-ups or proofs
  of concept for this. I spent quite a bit of time digging through the
  code and trying to understand some of the strange PHP that I
  encountered (strange for me, anyhow). I was stopped short when I
  couldn't investigate too much further. I had an understanding of
  what to do, but I needed to start checking if what I did worked. I
  wasn't sure how different files got loaded and when, and in trying
  to study this, I was thwarted. I tried injecting scripts into pages
  to print to the browser's JS console, but that was only visible if
  the page didn't refresh. I tried sleep statements, but I didn't see
  anything. 
- [SQL Injection](https://wpvulndb.com/vulnerabilities/8906) : Some of
  the vulnerable code for this exploit was not in my copy of WP,
  despite it being an early enough version. I tried searching for
  other candidates that could server the same purpose as the
  vulnerable code I didn't have, but I couldn't find anything
  immediately useful.
- `CVE-2017-8295` : This was Host Header Injection. I found this
  really interesting. This dealt with a vulnerability in PHPMailer.
  However, I could not find the vulnerable code. I think that, while
  the WordPress version was indeed 4.2, I don't think that PHPMailer
  was at an older version. I didn't have time to figure out more.


## License

    Copyright [2018] [Adam Ibrahim]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
