## Set up the Custom Scrape.py Ansible module

### Credit

- <https://github.com/particledecay/ansible-scrape/blob/master/scrape.py>

### Setup

- Download the <https://github.com/particledecay/ansible-scrape/blob/master/scrape.py> file and place as needed in your Ansible project.
- I do this vs a git clone as I want to audit what that script does.
- look at `tasks/system/ansible-modules.yaml` for how to set this up.

## Write a Task to Scrape a Version Number

- See `tasks/specialized/scrape-test.yaml` for a sample

## Generate/Test a regex

- <https://regex-generator.olafneumann.org/>
- <https://www.beautifyconverter.com/regex-tester.php>

## How to find XPath in Chrome

- Open Chrome and find a website
- Highlight the element you want the path to
- Right-click and choose *Inspect*
- Dev Tools will open, with the HTML tag selected (This is under *elements*)
- Right-click in the area where the tags are highlighted, and select *Copy*->*Copy XPath* can copy the XPath from the webpage
- You can now paste the Xpath where needed

This is the copied XPath.
