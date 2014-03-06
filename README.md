TSRPullThreshold
================

*Note: this class is still under construction and may be unstable under certain conditions.*

You can attach a pull threshold to any view, specifying the offset threshold and pull direction, which will then make that view "pullable" by dragging. If released past the offset threshold, the TSRPullThreshold object will fire a **finish** block; if under, the attached view will snap back to its original position and the **cancel** block will be called instead. Alternatively, TSRPullThreshold can be set to drawer mode, which will convert the attached view into a drawer, where releasing past the threshold will automatically pull the view into the specified "open" position.

Any TSRPullThreshold object can be enabled or disabled by using `setEnabled`. As TSRPullThreshold uses a pan gesture recognizer, you may want to use this to avoid other recognizer conflicts.

Normal Mode
================

Here's how you'd attach the pull threshold to a view in the normal mode:

``` Objective C
TSRPullThreshold *puller = [TSRPullThreshold attachToView:view
                         direction:kTSRPullDirectionRight
                         threshold:30.0f
                         pullBlock:^(CGFloat offset) {
                            
                             // This code calls as the view is pulled, allowing you to animate external elements as well based on
                             // the offset of the pull.
                             
                         } finishBlock:^{
                             
                             // This code is called when the view is released past the threshold.
                             
                         } cancelBlock:^{
                             
                             // This code is called when the view is released under the threshold.
                             
                         }];```

This allows quite a bit of flexibility. I use this method in Ascendance, a current project I'm working on, to provide a nice, responsive way to "swipe open" an array of icons across the bottom of the screen, by setting the position of the other icons in the `pullBlock`.

Drawer Mode
===============

Drawer mode is used if you have, say, a pull-down header notification system, or a pull-to-the-right menu similar to the one used in the Facebook mobile app.

``` Objective C
TSRPullThreshold *drawerpull = [TSRPullThreshold attachDrawerToView:view
                                                              direction:kTSRPullDirectionRight
                                                              threshold:30.0f
                                                               outPoint:0.0f
                                                              pullBlock:^(CGFloat offset) {
                                                                  
                                                                  // This code calls as the view is pulled, allowing you to animate
                                                                  // external elements as well based on the offset of the pull.
                                                                  
                                                              } finishBlock:^{
                                                                  
                                                                  // This code is called when the view is released past the threshold.
                                                                  
                                                              } cancelBlock:^{
                                                                  
                                                                  // This code is called when the view is released under the threshold.
                                                                  
                                                              }];```
                                                              
Any view can be set up with animated pull-to-open function with just that line of code. In this case `outPoint` is the offset to which the view will "snap" open. So in the above case, assuming a view with x origin at, say, -300.0f and width 320.0f, pulling on that 20.0f wide visible bar on the left, past 30.0f to the right, would cause to snap open and occupy the whole screen. Pulling back to the left would then close it in the same way.

You can programatically open or close a drawer using `closeDrawer` and `openDrawer`.