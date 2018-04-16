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
1. (Required) Vulnerability Name or ID
  - [ ] Summary: 
    - Vulnerability types:
    - Tested in version:
    - Fixed in version: 
  - [ ] GIF Walkthrough: 
  - [ ] Steps to recreate: 
  - [ ] Affected source code:
    - [Link 1](https://core.trac.wordpress.org/browser/tags/version/src/source_file.php)
1. (Required) Vulnerability Name or ID
  - [ ] Summary: 
    - Vulnerability types:
    - Tested in version:
    - Fixed in version: 
  - [ ] GIF Walkthrough: 
  - [ ] Steps to recreate: 
  - [ ] Affected source code:
    - [Link 1](https://core.trac.wordpress.org/browser/tags/version/src/source_file.php)
1. (Optional) Vulnerability Name or ID
  - [ ] Summary: 
    - Vulnerability types:
    - Tested in version:
    - Fixed in version: 
  - [ ] GIF Walkthrough: 
  - [ ] Steps to recreate: 
  - [ ] Affected source code:
    - [Link 1](https://core.trac.wordpress.org/browser/tags/version/src/source_file.php)
1. (Optional) Vulnerability Name or ID
  - [ ] Summary: 
    - Vulnerability types:
    - Tested in version:
    - Fixed in version: 
  - [ ] GIF Walkthrough: 
  - [ ] Steps to recreate: 
  - [ ] Affected source code:
    - [Link 1](https://core.trac.wordpress.org/browser/tags/version/src/source_file.php) 

## Assets

List any additional assets, such as scripts or files

## Resources

- [WordPress Source Browser](https://core.trac.wordpress.org/browser/)
- [WordPress Developer Reference](https://developer.wordpress.org/reference/)

GIFs created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I went through more than 3 exploits, but I hit dead ends in most of
them.



## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
