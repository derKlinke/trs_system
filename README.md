# TRS SYSTEM

TRS SYSTEM is a UI library for SwiftUI-based macOS applications. It implements the color scheme and other design ideas I set for all my projects and my website. For more info on the colors, see [my website](https://klinke.studio/fun/colors). It also implements a collection of dynamic colors that each have a UI function, such as contentBackground or secondaryContentBackground. These colors change automatically based on the system appearance.

In addition to colors based on the RAL color system, it also defines custom font styles for various functions, such as body, headline, or title. The fonts are checked on startup and downloaded to the user's system if they don't exist yet. The font sizes are all dynamically calculated based on a base size and the golden ratio. Paddings and corner sizes also follow this general formula.

In addition to a lot of style configuration, TRS SYSTEM also implements some custom UI elements, such as a custom List view that behaves similarly to a default List but is styled to integrate better into this design system.

## License

This code is open-sourced more as an example of how to do things and to inspire others to maybe also go the full crazy route and define their design system. However, I would ask you not to use it directly to keep the styling of my current and future applications unique.
