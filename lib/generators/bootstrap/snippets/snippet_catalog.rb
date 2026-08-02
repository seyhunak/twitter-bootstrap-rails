module Bootstrap
  module Generators
    # Every snippet published at https://getbootstrap.com/docs/5.3/examples/
    # Variants are listed in the order they appear on each docs page.
    module SnippetCatalog
      # generator name => docs category
      GENERATORS = {
        "header" => "headers",
        "hero" => "heroes",
        "features" => "features",
        "sidebar" => "sidebars",
        "footer" => "footers",
        "dropdown" => "dropdowns",
        "list_group" => "list-groups",
        "modal" => "modals",
        "badge" => "badges",
        "breadcrumb" => "breadcrumbs",
        "button" => "buttons",
        "jumbotron" => "jumbotrons",
      }.freeze

      VARIANTS = {
        "headers" => [
          { :name => "centered", :description => "Brand and centered nav pills with a bottom border", :icons => true },
          { :name => "nav_pills", :description => "Bare centered nav pills", :icons => false },
          { :name => "with_auth_buttons", :description => "Brand, nav, and Login / Sign-up buttons", :icons => true },
          { :name => "dark_search", :description => "Dark bar with search box and user dropdown", :icons => true },
          { :name => "light_search", :description => "Light bar with search box and user dropdown", :icons => true },
          { :name => "grid_dropdown", :description => "Full-width grid header with a brand dropdown and search", :icons => true },
          { :name => "double", :description => "Two-row header: utility links above, brand and nav below", :icons => true },
          { :name => "dark_double", :description => "Dark two-row header with nav and search", :icons => true },
        ],
        "heroes" => [
          { :name => "centered", :description => "Centered hero with heading, lead text, and buttons", :icons => false },
          { :name => "centered_screenshot", :description => "Centered hero with a screenshot below the fold", :icons => false },
          { :name => "with_image", :description => "Responsive left-aligned hero with an image", :icons => false },
          { :name => "signup_form", :description => "Vertically centered hero with a sign-up form", :icons => false },
          { :name => "cropped_image", :description => "Bordered hero with a cropped image and shadows", :icons => false },
          { :name => "dark", :description => "Dark colour hero", :icons => false },
        ],
        "features" => [
          { :name => "columns_with_icons", :description => "Three columns each led by an icon", :icons => true },
          { :name => "hanging_icons", :description => "Rows with icons hanging to the left of the text", :icons => true },
          { :name => "custom_cards", :description => "Feature cards with background images", :icons => true },
          { :name => "icon_grid", :description => "Compact grid of icons with short descriptions", :icons => true },
          { :name => "with_title", :description => "Left-aligned section title beside a feature grid", :icons => true },
        ],
        "sidebars" => [
          { :name => "dark", :description => "Dark sidebar with nav and a user dropdown", :icons => true },
          { :name => "light", :description => "Light sidebar with nav and a user dropdown", :icons => true },
          { :name => "icon_only", :description => "Narrow icon-only sidebar", :icons => true },
          { :name => "collapsible", :description => "Sidebar with collapsible nav sections", :icons => true },
          { :name => "list_group", :description => "Sidebar built from a scrollable list group", :icons => true },
        ],
        "footers" => [
          { :name => "simple", :description => "Copyright on the left, nav links on the right", :icons => true },
          { :name => "with_brand", :description => "Brand mark, copyright, and social icons", :icons => true },
          { :name => "with_nav", :description => "Centered nav above a centered copyright line", :icons => false },
          { :name => "columns", :description => "Five columns of links with a brand column", :icons => true },
          { :name => "with_newsletter", :description => "Link columns plus a newsletter sign-up form", :icons => true },
        ],
        "dropdowns" => [
          { :name => "simple", :description => "Menu of plain items with a divider", :icons => false },
          { :name => "with_search", :description => "Menu with a dark header and a search field", :icons => false },
          { :name => "with_icons", :description => "Menu items each led by an icon", :icons => true },
          { :name => "calendar", :description => "Date picker rendered inside a dropdown", :icons => true },
          { :name => "mega_menu", :description => "Wide multi-column menu with descriptions", :icons => true },
        ],
        "list-groups" => [
          { :name => "with_avatars", :description => "Items with an avatar, heading, text, and timestamp", :icons => false },
          { :name => "checkboxes", :description => "Checkbox items with supporting text", :icons => false },
          { :name => "checkboxes_expanded", :description => "Checkbox items that reveal more content when checked", :icons => true },
          { :name => "checkable", :description => "Borderless checkable cards", :icons => false },
          { :name => "radios", :description => "Radio cards with a selected state", :icons => false },
        ],
        "modals" => [
          { :name => "sheet", :description => "Bottom-docked modal sheet with a list of actions", :icons => false },
          { :name => "confirm", :description => "Small confirmation dialog with two buttons", :icons => false },
          { :name => "whats_new", :description => "\"What's new\" dialog listing recent features", :icons => true },
          { :name => "signup", :description => "Sign-up dialog with a form and third-party buttons", :icons => true },
        ],
        "badges" => [
          { :name => "pills", :description => "Solid pill badges in every theme colour", :icons => false },
          { :name => "subtle", :description => "Subtle background pill badges", :icons => false },
          { :name => "subtle_bordered", :description => "Subtle pill badges with a matching border", :icons => false },
          { :name => "with_avatar", :description => "Badges leading with a small round avatar", :icons => false },
          { :name => "with_icons", :description => "Badges with a trailing icon", :icons => true },
          { :name => "with_avatar_divider", :description => "Avatar badges split by a vertical divider", :icons => true },
        ],
        "breadcrumbs" => [
          { :name => "basic", :description => "Breadcrumb on a tinted, rounded background", :icons => false },
          { :name => "with_icons", :description => "Breadcrumb whose first crumb is a home icon", :icons => true },
          { :name => "chevron", :description => "Chevron separators instead of slashes", :icons => true },
          { :name => "custom", :description => "Arrow-shaped crumbs joined edge to edge", :icons => true },
        ],
        "buttons" => [
          { :name => "pills", :description => "Pill buttons in every theme colour", :icons => false },
          { :name => "grid", :description => "Full-width stacked buttons in a grid", :icons => false },
          { :name => "with_icons", :description => "Buttons with a trailing icon", :icons => true },
          { :name => "loading", :description => "Buttons with a spinner in the loading state", :icons => false },
          { :name => "circle", :description => "Round icon-only buttons", :icons => true },
        ],
        "jumbotrons" => [
          { :name => "with_icon", :description => "Jumbotron led by a large SVG icon", :icons => true },
          { :name => "placeholder", :description => "Faded jumbotron for placeholder content", :icons => true },
          { :name => "full_width", :description => "Edge-to-edge jumbotron with a contained body", :icons => false },
          { :name => "basic", :description => "Simple jumbotron inside a container", :icons => false },
        ],
      }.freeze

      module_function

      def category_for(generator_name)
        GENERATORS.fetch(generator_name)
      end

      def variants(category)
        VARIANTS.fetch(category)
      end

      def variant(category, name)
        variants(category).find { |v| v[:name] == name }
      end

      def variant_names(category)
        variants(category).map { |v| v[:name] }
      end

      def default_variant(category)
        variants(category).first[:name]
      end
    end
  end
end
