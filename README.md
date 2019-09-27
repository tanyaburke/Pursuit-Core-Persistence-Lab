# Pursuit-Core-Persistence-Lab

## Standards

- IOS.4.f: Use FileManager to persist information
- EF.10.h: Use URLSession to get data from online
- EF.10.f: Use Codable and JSONDecoder to parse JSON data

Use the Pixabay API to search for and favorite photos

Endpoint: 

```
https://pixabay.com/api/?key={YOUR API KEY GOES HERE}&q=
```

You can sign up here: https://pixabay.com/en/service/about/api/

##  Create a Tab Bar View Based Application

- In the first view controller there should be a search bar to search for photos
- Selecting a photo should segue to a detail view controller to show more details about the selected photo
- In the detail view controller, have a UIControl e.g UIButton to favorite a Photo
- The second view controller in the tab bar controller should be a table view of your favorites
- Selecting a favorites photo should segue to a detail view controller to show more details about the selected photo
- The favorite Photo Objects should be saved to the Documents folder using Codable
- Other properties of a Photo Object are: likes, favorites, tags, previewURL, webformatURL
- Photo Objects favorited should be able to persist through launches of the application


## Bonus 

- Allow the user to be able to delete a favorited Photo
- Allow the user to edit the properties in a favorited Photo
- Can share a favorite photo using a the built in iOS Share Sheet Using a UIActivityViewController
