# Anchors

> I like turtles. 
 

## Learning Objectives

* Create constraints in code using Anchors which will allow for you to layout the views in your iOS app (not using Interface Builder to create the constraints).

## Auto Layout

![](https://s3.amazonaws.com/learn-verified/AnchorInterfaceBuilder.png)

In Interface Builder, I've dragged over a View object onto the View Controller, gave it a background Color of red and called it Top View.

After doing so, I've created an outlet from this view object to the `ViewController.swift` file.

![](https://s3.amazonaws.com/learn-verified/AnchorViewController.png)

We're missing something. We haven't added any constraints yet. I want this `topView` to fill out half the screen and be constrained to the top, left and right of the `view`. We know how we can do that in Interface Builder, so lets do that:

![](https://s3.amazonaws.com/learn-verified/AnchorFullView.png)

The four constraints made were as follows:

![](https://s3.amazonaws.com/learn-verified/AnchorConstraints.png)

Can we programmatically create these constraints? Yes.

Before we begin writing any code, take a look at makes up one of these constraints, lets take a look at the height one first.

Top View.Height - Equal - Superview.Height ; Constant = 0, Multiplier = 0.5

It _almost_ reads like a sentence. We're taking out Top View object which seems to have some sort of .Height property and telling that property to equal something else. We're having it equal its Superview's .Height property. What is its Superview, it's one view up.. meaning where _does_ this Top View live? It lives within the `View` object (the thing with the white background right now). There's this Multiplier property here we're manipulating--it defaults to 1.0 but we've set it to 0.5 which tells our program.. HEY I want you to be exactly HALF the height of the Superview.Height.

Here's the current state of our app with the constraints we have now:

![](https://s3.amazonaws.com/learn-verified/AnchorCurrentState.png)

Lets blow away the constraints now to get us back to square one. We're back to our View Controller Scene looking like this (with no constraints):

![](https://s3.amazonaws.com/learn-verified/AnchorInterfaceBuilder.png)

Lets head over to the `ViewController.swift` file, specifically to the `viewDidLoad()` method. We know we have an outlet from this view labeled as `topView` that we can manipulate. We know very easily we can change the `backgroundColor` property of this `topView` if we wanted like so:

```swift
topView.backgroundColor = UIColor.blueColor()
```

If we were to run our app now, it would look like this:

![](https://s3.amazonaws.com/learn-verified/AnchorBlue.png)

Similar to how we can manipulate the `backgroundColor` of a `UIView` instance (like we have here), we can do the same with constraints.

Here are the four instance properties on `topView` that we will be manipulating:

```swift
topView.leftAnchor
topView.rightAnchor
topView.topAnchor
topView.heightAnchor
```

Lets start with the `heightAnchor` property--similar to above (the constraint we created in Interface Builder), we want to create this:

Top View.Height - Equal - Superview.Height ; Constant = 0, Multiplier = 0.5

The types of these four instance properties are `NSLayoutAnchor`. And if we do some digging into this class, it has a few methods available to us which will help us solve our problem here (which is creating constraints in code).

An instance of `NSLayoutAnchor` (which is what these four instance properties are) have these three methods available to them (amongst a few other):

`constraintEqualToAnchor(_:)`  
`constraintEqualToAnchor(_:constant:)`   
`constraintEqualToAnchor(_:multiplier:)`

As the first argument to each of these three methods, the argument is of type `NSLayoutAnchor`.  We can then pass in a constant or multiplier value to adjust the constraint some (just like us using the multiplier above with our height constraint to make it half the height of the iPhone).

Lets create our first constraint in code (working with the height first):

```swift
topView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.5)
```

We're calling on the `constraintEqualToAnchor(_:multiplier:)` method available to any instance of `NSLayoutAnchor`, which is what the `heightAnchor` on the `topView` instance is! Calling on this method, we have to give it what it wants. As its first argument, it wants another instance of `NSLayoutAnchor`--so we give it that! The `view` property is the the white background that we see when we launch the app. So we access the `heightAnchor` instance property on this `view` object and pass that into this method call. As well, we want it to be half the height of this this view object we pass along to this function--so we pass in 0.5

This is how you create a constraint in code which is the exact same thing as doing this in Interface Builder:

Top View.Height - Equal - Superview.Height ; Constant = 0, Multiplier = 0.5

There's one thing we need to add to this though. If you dig into the documentation, doing this returns back to us an Inactive constraint. It means we need to Activate it! How do we do that.. you do that like this:

```swift
topView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.5).active = true
```

It's the same line of code with one addition. We're accessing the return value of this functions `.active` instance property (which is of type `Bool`) and assigning it the value `true` which will _activate_ this particular constraint. So.. wait, what? Return value of this function? So `constraintEqualToAnchor(_:multiplier:)` and those other functions above return back something? Yes. It returns back to us a value of type `NSLayoutConstraint!`. Like any other call to a function we make, we can store it in some variable or constant, or do nothing with it. Here, we're not storing it in some variable or constant but we are _doing_ something with it, we're accessing its `.active` instance property setting it to `true` all in one line of code.

Lets add our other constraints which are much easier compared to the height:

```swift
topView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
topView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
topView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
```

After doing so, lets run our app:

![](https://s3.amazonaws.com/learn-verified/AnchorBlueDone.png)

Nice, we did it!

There's .... one more thing.

![](https://media.giphy.com/media/CTkWFZ1IDvsfS/giphy.gif)

There's an instance property on every single `UIView` instance that we need to assign a value to. The name of this instance property is `translatesAutoresizingMaskIntoConstraints` and its of type `Bool`. Its default value is set to `true`.

What... is... that?

Here's Apples definition of this instance property in its documentation:

By default, the autoresizing mask on a view gives rise to constraints that fully determine the view's position. This allows the auto layout system to track the frames of views whose layout is controlled manually (through -setFrame:, for example). **When you elect to position the view using auto layout by adding your own constraints, you must set this property to NO. IB will do this for you.**

I bolded (is that a word) the more important part of this definition. Each `UIView` is able (to some degree) lay itself out on screen, but it's on you the developer to decide how and where you want to lay out your `UIView`through Auto Layout. When we want to setup constraints ourself we need to set this instance property to `false` or If were to do this in Interface Builder (like we have been doing before you learned about anchors), Interface Builder will set this property to `false` for us (which is great!). 

Since we're not adding our constraints in Interface Builder here, we have to manually set this instance property to `false` which will allow for our constraints to work. 

Here's what our `viewDidLoad()` function looks like at the end of the day:

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = UIColor.blueColor()
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.5).active = true
        topView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        topView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        topView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
    }
```

<a href='https://learn.co/lessons/Anchors' data-visibility='hidden'>View this lesson on Learn.co</a>
