# RJLcode.github.io

Link hub for RJLcode projects, live at <https://rjlcode.github.io/>.
Plain HTML and CSS in a single `index.html`, no build step.

## Add a project

1. Take a Mac screenshot and an iPhone screenshot of the live site.
2. Make the thumbnails (needs `brew install webp`):

   ```bash
   tools/add-screenshots.sh <repo-name> path/to/mac.png path/to/iphone.png
   ```

3. In `index.html`, find the block marked **PROJECT LIST: START**. Copy one
   `<li class="card">` block, paste it in position (newest first), and change
   the image paths, alt text, title, description, tags, Updated date and
   repo, Open link and Code link.
   - **Tags:** keep one category tag (for example `Aviation`, `Space`,
     `Sports`, `Public Safety`). Keep `<li class="live">Live data</li>` only
     if the app pulls real-time feeds; delete that line otherwise.
   - **Updated:** set `data-repo` to `RJLcode/<repo-name>`. The page fetches
     the latest commit date from GitHub on load; the date written in the HTML
     is the fallback.
   - Long descriptions are fine: cards show the first three lines.

   Take the description and live URL from the repo's About field:

   ```bash
   gh repo view RJLcode/<repo-name> --json description,homepageUrl
   ```

4. Commit and push. GitHub Pages republishes within a minute or two.

## Files

- `index.html`: the page, with the project list in one marked section
- `img/`: logo, share image, icons and project thumbnails
- `RJLcode_Brand/`: original brand files (logo and icon, black and white)
- `tools/add-screenshots.sh`: crops, resizes and compresses screenshots to WebP
