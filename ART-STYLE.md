# Go-Slow art style guide

Use this to make new characters and backgrounds that sit naturally beside the existing ones. `art-source/cast-sheet.jpg` shows the whole cast side by side; keep it open while you work.

## The look

- **Semi-realistic digital painting**, soft and warm, clean edges, slightly stylised (think polished mobile story-game art, not photographs and not cartoons).
- **Characters:** one person, **full body head to shoes**, standing, facing the viewer, relaxed confident pose, friendly or in-character expression. Modern Lagos office wear, ankara or aso-oke for older or senior characters.
- **Backgrounds:** bright, sunny, detailed Lagos interiors and streets, eye-level view, no people in the foreground, a little soft blur so characters stand out.
- **Palette:** warm daylight, danfo yellow `#F7C948`, orange `#E8590C`, rich greens and blues.

## Sizes the game expects

| Asset | Format | Size | Where |
|---|---|---|---|
| Character | PNG with a **transparent** background | 360 × 540 px (2:3 portrait) | `web/art/name.png` |
| Background | JPG | about 920 × 613 px (3:2 landscape) | `web/art/place.jpg` |
| App icon | PNG | 192 × 192 and 512 × 512 | `web/icon-192.png`, `web/icon-512.png` |

Keep the full-size original in `art-source/` before you shrink it.

## Prompt templates for any free AI image tool

(Microsoft Designer / Bing Image Creator, Leonardo, Ideogram and similar tools all work. Check each tool's terms on commercial use if you plan to sell the game.)

**Character**
> Full-body semi-realistic digital painting of [a Nigerian woman in her late 20s with shoulder-length braids], wearing [a mustard blouse and black trousers with low heels], standing facing the viewer, [warm, playful smile], polished mobile story-game art style, soft studio lighting, entire figure visible from head to shoes, plain light grey background, centred, portrait 2:3

**Background**
> Semi-realistic digital painting of [a busy Lagos open-air market at midday, colourful umbrellas, stalls of peppers and fabrics], eye-level view, bright warm sunlight, detailed, no people in the foreground, mobile story-game background art, landscape 3:2

## Free tools to finish the picture

1. **Remove the background:** remove.bg or Photopea (Select → Remove BG). Download as PNG.
2. **Resize and crop:** Photopea (photopea.com): Image → Canvas Size to make it 2:3 with the figure centred and feet near the bottom, then Image → Image Size to 360 × 540. File → Export as → PNG.
3. **Backgrounds:** Image → Image Size to 920 px wide, export as JPG at about 80% quality to keep the game fast on phones.

## Existing cast notes (keep them consistent)

| Id | Look |
|---|---|
| `you` (look 1) | Young woman, natural afro puff, cream blouse, black trousers, heels, shoulder bag |
| `you` (look 2) | Young woman, long box braids, white shirt, beige trousers, white trainers |
| `you` (look 3) | Young man, short hair, pale yellow short-sleeved shirt, navy trousers, brown shoes |
| `bello` | Mrs. Bello, HR. Older woman, purple gele, patterned purple and brown peplum blouse, purple pencil skirt, arms folded |
| `oga` | The Oga. Grey-haired older man, navy suit, maroon tie |
| `ada` | Long wavy hair, light blue shirt, beige trousers, loafers, brown handbag |
| `tunde` | Security. Short hair, navy work shirt with a name badge, black trousers |
| `chidi` | Light blue shirt, navy trousers, brown shoes, big friendly grin, pointing |
| `emeka` | Rival. Navy suit, red tie, pocket square, arms crossed, smug |
| `auditor` | Dark suit, glasses, briefcase, cold expression |
| `nkechi` | Journalist. Curly hair, camel blazer, jeans, press lanyard, phone in hand |
| `md` | Chief Mrs. Balogun. Gold gele, purple and gold embroidered gown with gold shawl, regal |
