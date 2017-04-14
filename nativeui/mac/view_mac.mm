// Copyright 2016 Cheng Zhao. All rights reserved.
// Use of this source code is governed by the license that can be found in the
// LICENSE file.

#include "nativeui/mac/view_mac.h"

#include "nativeui/container.h"
#include "nativeui/gfx/geometry/point_conversions.h"
#include "nativeui/gfx/geometry/rect_conversions.h"
#include "nativeui/gfx/mac/painter_mac.h"
#include "nativeui/mac/events_handler.h"

namespace nu {

void View::PlatformDestroy() {
  [view_ release];
}

void View::TakeOverView(NativeView view) {
  view_ = view;

  // Install events handle for the view's class.
  if (IsNUView(view) && !EventHandlerInstalled([view class])) {
    AddMouseEventHandlerToClass([view class]);
    AddKeyEventHandlerToClass([view class]);
  }
}

void View::SetBounds(const RectF& bounds) {
  NSRect frame = bounds.ToCGRect();
  [view_ setFrame:frame];
  // Calling setFrame manually does not trigger adjustSubviews.
  [view_ resizeSubviewsWithOldSize:frame.size];
}

RectF View::GetBounds() const {
  return RectF([view_ frame]);
}

void View::SetPixelBounds(const Rect& bounds) {
  SetBounds(RectF(bounds));
}

Rect View::GetPixelBounds() const {
  return ToNearestRect(GetBounds());
}

void View::PlatformSetVisible(bool visible) {
  [view_ setHidden:!visible];
}

bool View::IsVisible() const {
  return ![view_ isHidden];
}

void View::PlatformSetBackgroundColor(Color color) {
  if ([GetNative() respondsToSelector:@selector(setNUBackgroundColor:)])
    [GetNative() setNUBackgroundColor:color];
}

}  // namespace nu
