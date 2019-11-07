> position, float, align, text-align, valign, flexbox, grid

## Positioning

### `display`

"Block" and "inline" display define the two main axes of document flow. Display boxes have outer and inner display values; `block` and `inline` refer to outer values.

* `block`: full width, new line
* `inline`: within flow
  * `width`, `height` do not apply
  * `margin` does not affect other elements
* `inline-block`: inline, but respect width and height, and margin affects other elements.

`box-sizing: border-box` includes border and padding in the `width` and `height` values, which is the only sensible way to do it.

`margin` collapsing: adjacent margins will overlap each other in these cases:

* adjacent siblings
* parent & child when no padding, clearance, etc separate the elements tops (or bottoms)
* top and bottom margin when no content, padding, clearance, etc separate them.

### `position`

* `static`: default. Normal document flow.
  * no effect of `left`, `right`, `top`, `bottom`, `z-index`
* `relative`: like static, nudged by `left`, `right`, `bottom`, `top`, `z-index`.
* `absolute`: removed from document flow, placed relative to parent. Ignores other elements and other elements ignore it.
* `fixed`: removed from document flow, placed relative to document.
* `sticky`:

### The containing block

* `absolute` elements' containing block is padding-box of the nearest non-`static` ancestor (`absolute`, `relative`, `fixed`, or `sticky`).
  * This *also* includes parents with non-`none` `transform` properties.
* `fixed` elements' containing block is the viewport.
* `absolute` or `fixed` elements' containing blocks are, instead, the padding box of the nearest ancestor with `transform` or `perspective` that is not `none`, a `will-change` property of `transform` or `perspective`, a non-`none` `filter` or `will-change` of `filter`, or `contain` value of `paint`
* Other (`static`, `relative`, and `sticky`) elements' containing blocks are the content area of its nearest block-level ancestor or ancestor that established a formatting context (BFC, flex, table, grid).

### Block Formatting Context

Block formatting context will contain its elements. Think of it as its own, self-contained full layout within the document; things don't "poke out" of a BFC element. Block formatting context elements will also not wrap around floats but stay "in their lane".

A div does not have BFC by default, and as such it can end prior to the end of any of its content removed from normal flow (e.g. float, absolute).

Block formatting context is established by:

* `overflow`: any value other than `visible`
* `position`: `absolute` or `fixed`
* `display`: `inline-block`, `table-cell`, `table-caption`
* `column-span`: `all`
* `display`: `flow-root` -- this is not well supported but the only option that is *exclusively* for creating block formatting context with no other side effects.

`flex` and `grid` don't quite create block formatting context, but `flex` and `grid` formatting contexts instead. These act similarly but should be considered on their own.

## Units

* absolute length
  * `cm`, `mm`, `Q` (1/4 mm), `in`, `pc` (1/16 in), `pt` (1/72 in), `px` (1/96 in)
* relative length
  * `em`: font size of parent element
  * `ex`: x-height of font
  * `ch`: width of `0`
  * `rem`: font size of root element
  * `lh`: line height
  * `vw`: 1% of viewport width
  * `vh`: 1% of viewport height
  * `vmin`: min(vw, vh)
  * `vmax`: max(vw, vh)
* percentage
  * relative to same property on parent
  * percent margin and padding use percent of inline dimension

## Selectors

`element#id.class[attr=value]`

### attribute selectors

* (name only): match elements containing the attribute
* `=`: match attribute exactly
* `~=`: match attribute exactly *or* one-of class attributes
* `|=`: match `/#{value}(-.*)?`
* `^=`: match `/^#{value}/`
* `$=`: match `/#{value}$/`
* `*=`: match `/#{value}/`
* `i`, as in `[name=thor i]`: use case-insensitive matching

## Pseudo-classes

* `:first-child`, `:last-child`
* `:only-child`
* `:nth-child(an+b)`, `:nth-last-child`
* `:hover`
* `:focus`
* `:is`, `:not`
* `:blank`, `:checked`, `:indeterminate`
* `:disabled`, `:enabled`
* `:valid`, `:invalid` (input elements)

and [many more](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Selectors/Pseudo-classes_and_pseudo-elements#Pseudo-classes)

## Pseudo-element

* `::before`
* `::after`
* `::selection`
* `::first-line`
* `::first-letter`
* `::grammar-error`
* `::spelling-error`

## Normalize & Reset

Normalize: make all browsers act the same. This can mean applying IE styles to all browsers since IE does not allow the `any` selector.

https://github.com/necolas/normalize.css/blob/master/normalize.css

Reset: ditch all user-agent styling.

```css
/* http://meyerweb.com/eric/tools/css/reset/
   v2.0 | 20110126
   License: none (public domain)
*/

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed,
figure, figcaption, footer, header, hgroup,
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
	margin: 0;
	padding: 0;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
	display: block;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}
```

Or use a combo: reset specific elements, not all, and normalize others.

```css
/****** Elad Shechter's RESET *******/
/*** box sizing border-box for all elements ***/
*,
*::before,
*::after{box-sizing:border-box;}
a{text-decoration:none; color:inherit; cursor:pointer;}
button{background-color:transparent; color:inherit; border-width:0; padding:0; cursor:pointer;}
figure{margin:0;}
input::-moz-focus-inner {border:0; padding:0; margin:0;}
ul, ol, dd{margin:0; padding:0; list-style:none;}
h1, h2, h3, h4, h5, h6{margin:0; font-size:inherit; font-weight:inherit;}
p{margin:0;}
cite {font-style:normal;}
fieldset{border-width:0; padding:0; margin:0;}
```

Form reset:

```css
button,
input,
select,
textarea {
  font-family: inherit;
  font-size: 100%;
  box-sizing: border-box;
  padding: 0; margin: 0;
}

textarea {
  overflow: auto;
}
```
