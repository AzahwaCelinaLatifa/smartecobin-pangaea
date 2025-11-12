# Smart EcoBin Design Guidelines

## Design Approach
**Reference-Based Approach**: Modern eco-tech application inspired by clean dashboard interfaces like Notion and Linear, with glassmorphism effects popularized by iOS design patterns.

## Core Design Elements

### A. Color Palette
- **Primary Gradient**: `linear-gradient(135deg, #00A86B 0%, #006241 100%)` - eco-green gradient for headers, buttons, and key elements
- **Accent Color**: `#C9A66B` - gold accent for highlights, active states, and premium elements
- **Background**: `#F6F5F2` - warm cream for main backgrounds
- **Glassmorphism**: Semi-transparent white backgrounds with backdrop-blur for cards and modals

### B. Typography
- **Font Family**: Poppins or Nunito Sans (Google Fonts)
- **Hierarchy**:
  - Page titles: 28-32px, bold
  - Section headings: 20-24px, semibold
  - Body text: 14-16px, regular
  - Small text/labels: 12-14px, medium

### C. Layout System
- **Spacing Units**: Tailwind-equivalent spacing - primarily 4, 8, 12, 16, 24, 32px
- **Border Radius**: 12-20px for cards, 8-12px for buttons, 50% for circular elements
- **Shadows**: Soft, layered shadows (0 4px 12px rgba(0,0,0,0.08))
- **Mobile-First**: Responsive breakpoints at 768px (tablet) and 1024px (desktop)

### D. Component Library

**Navigation**:
- Bottom navigation bar (mobile) with 5 icons: Dashboard, Monitoring, Control, Notifications, Profile
- Fixed position, glassmorphism background, active state with gradient indicator

**Cards**:
- Glassmorphism effect: `background: rgba(255,255,255,0.7)`, `backdrop-filter: blur(10px)`
- Rounded corners (16-20px), soft shadows
- Hover: Subtle lift effect (translateY -2px, increased shadow)

**Buttons**:
- Primary: Eco-gradient background, white text, rounded
- Secondary: White background, gradient text/border
- Social Login: White background, brand icons, subtle shadow
- Hover/Active: Scale 0.98, slight brightness increase

**Forms**:
- Input fields: White background, subtle border, rounded (8px)
- Focus state: Gradient border highlight
- Labels: 14px, medium weight, positioned above inputs

**Charts**:
- Gradient bar chart for trash volume with eco-green gradient fills
- Smooth animations on load
- Tooltip on hover showing exact values

**Map**:
- Color-coded markers: Green (normal), Yellow (80% full), Red (critical)
- Slide-up panel from bottom with bin details
- Interactive markers with scale animation on hover

**Tabs**:
- Horizontal tabs with underline indicator (gradient)
- Active tab: Bold text with gradient underline
- Smooth slide animation for indicator

**Notifications**:
- Icon-based with color coding: Blue (normal), Orange (full alert), Red (critical)
- Timestamp, status badge, and dismiss action
- Soft background tints matching severity

**Profile Elements**:
- Circular avatar (80-100px)
- Toggle switches with gradient active state
- Editable fields with inline edit icons

### E. Page-Specific Layouts

**Login Page**: Full-screen gradient background, centered glassmorphism card (max-width 400px), logo, form fields, social buttons

**Role Selection**: Two large cards side-by-side (desktop) or stacked (mobile), icons at top, title, description, hover elevation

**Dashboard**: Grid layout with summary cards (4 columns desktop, 2 mobile), bar chart section, trash categories with icon grid

**Trash Monitoring**: Full-height map container, floating search/filter controls, slide-up panel (40% height when active)

**Control Compartment**: Modular grid (2-3 columns desktop), system metrics cards, command buttons with confirmation states, emergency section with red accent

**Notifications**: Tabbed header, scrollable notification list, empty state illustration when no notifications

**User Profile**: Header with avatar and name, form sections with subtle dividers, settings toggles, logout button at bottom

### F. Interactions & Animations
- Page transitions: Fade-in (300ms)
- Card hover: Lift effect (200ms ease)
- Button clicks: Scale down (0.98) then return
- Chart animations: Stagger bar growth on load
- Map markers: Bounce on click, pulse for critical bins
- Toggle switches: Smooth slide (250ms)
- Tab switching: Slide indicator (300ms cubic-bezier)

### G. Icons
- Use **Font Awesome** or **Heroicons** via CDN
- Eco-themed icons: leaf, recycle, trash-bin, location-pin
- Navigation icons: dashboard, map, sliders, bell, user
- Consistent 20-24px size for UI icons, 32-48px for feature icons

### H. Responsive Behavior
- **Mobile (<768px)**: Single column, bottom nav, stacked cards, full-width elements
- **Tablet (768-1024px)**: 2-column grids, side nav optional, medium card sizes
- **Desktop (>1024px)**: Multi-column grids, full layouts, hover states active

### I. Glassmorphism Implementation
- Background: `rgba(255,255,255,0.6-0.8)`
- Backdrop filter: `blur(10px) saturate(180%)`
- Border: `1px solid rgba(255,255,255,0.3)`
- Apply to: Login card, navigation bar, info panels, modals

This application uses static demo data for all charts, maps, and metrics. Focus on premium visual polish, smooth transitions, and consistent eco-theme throughout all 7 pages.