# TRS SYSTEM

TRS SYSTEM is a UI library for SwiftUI based macOS Applications. It implements the color scheme and other design ideas I 
set for all my projects and my website. For more info on teh colors see [my website](https://klinke.studio/fun/colors).
It also implements a collection of dynamic colors that each have a UI function, such as contentBackground or 
secondaryContentBackground. These colors change automaticaly based on the system appearance. 

Additionally to colors based on the RAL color system it also defines custom font styles for various functions, such as 
body, headline or title. The fonts are checked on startup and downloaded to the users system if they dont exist yet. 
The font sizes are all dyanmically calculated based on a base_size and the golden ratio. Paddings and corner sizes also
all follow this general formula. 

Next to a lot of style configuration TRS SYSTEM also implements some custom UI elements, such as a custom List view that
behaves similarily to a default List, but is styled to integrate better into this design system. 

## License

This code is open sourced more as an example on how to do things, and to inspire others to maybe also go the full crazy 
route and define their own design system. However I would ask you to not use it directly, to keep the styling of my 
current and future applications unique.
