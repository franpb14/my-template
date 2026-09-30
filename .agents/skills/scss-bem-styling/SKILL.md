---
name: scss-bem-styling
description: SCSS architecture, BEM naming conventions, view integration with Rails ERB and Ralix components, responsive design, and layout patterns for this project.
---

# SCSS and BEM Styling

Modular SCSS architecture with BEM methodology for Rails views and Ralix components. Mobile-first responsive design with safe area support.

## When to Use This Skill

- Writing or refactoring SCSS styles in this project
- Creating new component styles following BEM
- Integrating styles with Rails ERB views and Ralix components
- Implementing responsive design with breakpoints
- Using body classes for page-specific styling

## SCSS Architecture

### Directory Structure

```
app/assets/stylesheets/
├── application.scss          # Main entry point (imports all)
├── base/                    # Foundation styles
│   ├── _variables.scss      # Colors, breakpoints, containers
│   ├── _mixins.scss         # Reusable mixins
│   ├── _reboot.scss         # CSS reset/normalize
│   ├── _fonts.scss          # Font definitions
│   ├── _buttons.scss        # Button styles and mixins
│   ├── _forms.scss          # Form input styles
│   └── ...
├── module/                  # Reusable components
│   ├── _header.scss
│   ├── _modal.scss
│   ├── _snackbar.scss
│   ├── _tables.scss
│   └── ...
└── layouts/                 # Layout-specific styles
    ├── _main.scss
    ├── _profile.scss
    └── ...
```

### Import Order

Always maintain: **base → modules → layouts**

```scss
// 1. Base foundation
@import "base/fonts";
@import "base/variables";
@import "base/mixins";
@import "base/reboot";
@import "base/forms";
@import "base/buttons";
// ... other base

// 2. Reusable modules (components)
@import "module/header";
@import "module/footer";
@import "module/tables";

// 3. Layout-specific styles
@import "layouts/main";
@import "layouts/profile";
```

## BEM Naming Conventions

### Patterns

**Block:** Standalone component (`.modal`, `.snackbar`, `.btn`)
**Element:** Part of a block (`.modal__background`, `.snackbar__close`)
**Modifier:** Variation (`.btn--primary`, `.snackbar--alert`)

### Examples

```scss
// Blocks
.modal-container { }
.snackbar { }
.table-header { }

// Elements
.modal__background { }
.modal__close { }
.snackbar__close { }
.table-header__first-row { }

// Modifiers
.btn--primary { }
.btn--transparent { }
.snackbar--alert { }
.modal-container--fullscreen { }

// State classes
.disable-scroll { }
.active { }
.hidden { }
.out { }  // For animations
```

### File Naming

- **Partials**: Leading underscore `_modal.scss`, `_snackbar.scss`
- **Module files**: Name after component `_modal.scss`
- **Layout files**: Name after layout `_main.scss`, `_profile.scss`

## Variables

Use variables from `base/_variables.scss`:

```scss
// Breakpoints
$breakpoint-xs: 480px;
$breakpoint-sm: 615px;
$breakpoint-md: 768px;
$breakpoint-lg: 1025px;
$breakpoint-xl: 1400px;

// Container max widths
$container-max-width-xs: 330px;
$container-max-width-md: 600px;
$container-max-width-lg: 800px;
$container-max-width-xl: 1240px;
$container-max-width-xxl: 1600px;

// Semantic colors
$primary-color: $black;
$secondary-color: $purple;
```

**Best Practices:**
- Always use variables instead of hardcoded values
- Use semantic color names
- Define breakpoints once

## Mixins

```scss
// Font size (responsive)
@mixin font-size($size) {
  font-size: $size !important;
  @media (min-width: $breakpoint-md) {
    font-size: calculateRemDt($size) !important;
  }
}

// Button variants
@mixin btn($bg, $color, $border-color) {
  background: $bg;
  color: $color;
  border: 1px solid $border-color;
  padding: 0 2em 0;
  height: 48px;
  @include font-size(13px);
}

// Safe area for iOS notch
@function safe-area($area, $size: 0px) {
  @if index((top bottom left right), $area) {
    @return calc(#{$size} + var(--safe-area-inset-#{$area}));
  }
  @return $size;
}

// Usage
header {
  height: safe-area(top, 60px);
  padding-top: safe-area(top);
}
```

## Nesting

- **Limit to 2-3 levels**
- Use BEM naming to avoid deep nesting
- Nest modifiers and pseudo-classes appropriately

```scss
// Good
.modal-container {
  position: fixed;

  &.revealing {
    transform: scale(1);
    .modal__background .modal {
      animation: scaleUp .5s forwards;
    }
  }
}

// Avoid: Too deep
.container .row .col .card .card-body .text { }
```

## Responsive Design

### Mobile-First

```scss
.component {
  // Mobile (default)
  width: 100%;
  padding: 1em;

  @media (min-width: $breakpoint-md) {
    width: 50%;
    padding: 2em;
  }

  @media (min-width: $breakpoint-lg) {
    width: 33.33%;
  }
}
```

### Safe Area Support

Apply to header, footer, and fixed elements for iOS notch:

```scss
header {
  height: safe-area(top, 60px);
  padding-top: safe-area(top);
}

.container {
  padding-bottom: safe-area(bottom, 60px);

  @media (min-width: $breakpoint-md) {
    padding-bottom: safe-area(bottom, 0);
  }
}
```

## View Integration

### ERB Templates

```erb
<div class="table-header-container">
  <div class="table-header">
    <div class="table-header__first-row">
      <h2 class='hl--view mb-0-md-up txt-left-md'>
        <%= t('patient.patients') %>
      </h2>
    </div>
  </div>
</div>
```

### Body Classes

Layout adds body classes: `{controller}-{action}` (e.g., `patients-index`, `users-edit`)

```scss
body.patients-index {
  .container {
    padding-bottom: safe-area(bottom, 60px);
  }
}
```

### Helper Integration

```erb
<%= icon 'help', css_class:"header-link-icon__icon_help" %>
<%= modal_link_to(new_patient_path, class: 'btn btn--primary') do %>
  <%= icon 'add', css_class:"btn__icon" %>
  <span class="btn__txt"><%= t('patient.new') %></span>
<% end %>
```

## Ralix Component Integration

- **Modal**: JavaScript `Modal` class + CSS `.modal-container`, `.modal__background`, `.modal__close`
- **Snackbar**: View `_flash_messages.html.erb` + CSS `.snackbar`, `.snackbar--alert`
- **Pattern**: Define CSS classes (BEM) → Create Ralix component → Use data attributes or class toggles

## Layout Patterns

### Container System

```scss
.container {
  min-height: 100vh;
  width: 100%;
  max-width: $container-max-width-xxl;
  margin: 0 auto;
}

.content-wrap {
  max-width: $container-max-width-xl;
  margin: 2em auto;
  padding: 0 1em;
}
```

### Grid and Flexbox

```scss
.header-link-group--right {
  display: flex;
  align-items: center;
  gap: 1em;
}

.input-group--two-cols {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-column-gap: 2em;
}
```

## File Creation Checklist

When creating new styles:
- [ ] Determine if base, module, or layout
- [ ] Use BEM naming convention
- [ ] Use variables for colors, breakpoints, containers
- [ ] Follow mobile-first responsive approach
- [ ] Import in correct order in `application.scss`
- [ ] Consider safe areas for fixed elements
