# Task-Tracker

<img src="https://github.com/TanyEm/Task-Tracker/blob/main/task_tracker.gif" height="480"> <img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/1.png" height="500"> <img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/2.png" height="500"> <img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/3.png" height="500"> <img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/4.png" height="500"> <img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/5.png" height="500"> <img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/6.png" height="500"><img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/7.png" height="500"><img src="https://github.com/TanyEm/Task-Tracker/blob/main/reenshots/8.png" height="500">
## Description

I decided to use **MVC** architecture with **services** as DataManager, GesturesHendler, etc and twithout hird party libraries. Also, I made persistent storage as saving **files to disk**. I added guest access to **hide private task** (without pin code) and added own access with biometrics recognise via **FaceID/TouchID** and through pin code, if biometric don't recognise or not available. When the work was almost completed I added animation on the first screen just make it more beautiful and fun and added icons on the tab bar.

### Implementation notes

I decided to use the ```FileManager``` to save tasks into TaskListItem.plist, also I used ```DataManager``` to implement CRUD opirations.

On the ```TaskManagerTableViewController```, the user has the ability to enter large text and the TextView will expand, but on the ```TasksListTableViewController``` will appear only 7 lines to make it convenient while a user viewing tasks the user can always open the task to read a large text.

I decided to add a pin code screen to add an ability to enter the application using the pin code if biometric don't recognise or not available. At the moment, the pin code is not set in the implementation, you can enter into the Task list with any pin code.

In the guest mode, the user cannot create private tasks.

I implemented **test** coverage to CRUD operations of ```DataManager```.

I decided to add animation but it is difficult for the simulator to display animation, for this reason, this line of code is documented. If you want to explore it uncomment it in WelcomeViewController. 

```swift
override func viewWillAppear(_ animated: Bool) {
    super .viewWillAppear(animated)
        
//        makeFlyingEmoji()
        
    ownerButton.layer.cornerRadius = 15
    guestButton.layer.cornerRadius = 15
}
```

Also, I would recommend you to use a real iPhone to view the animation.

I implemented local push notifications if a user didn't complete a task before the due date.

### Things to improve

- Add Core Data insted of File Manager for large data
- Add a signing in to add a pin code into keychain


## Xcode Project Setup

### Requirements

> A code signing key from Apple is required to deploy apps to a device. Without a developer key, the app can only be installed on the iPhone Simulator.

- Xcode  
- iOS 14 SDK
