//
//  MyGenmetry.h
//  WarmHome
//
//  Created by huafangT on 16/10/28.
//
//

#ifndef MyGenmetry_h
#define MyGenmetry_h

CG_INLINE CGRect
CGViewGetFrame(UIView *view)
{
    return view.frame;
}

CG_INLINE CGRect
CGViewGetBounds(UIView *view)
{
    return view.bounds;
}

CG_INLINE CGFloat
CGViewGetWidth(UIView *view)
{
    return CGRectGetWidth(view.bounds);
}

CG_INLINE CGFloat
CGViewGetHeight(UIView *view)
{
    return CGRectGetHeight(view.bounds);
}

CG_INLINE CGFloat
CGViewGetX1(UIView *view)
{
    return CGRectGetMinX(view.frame);
}

CG_INLINE CGFloat
CGViewGetY1(UIView *view)
{
    return CGRectGetMinY(view.frame);
}

CG_INLINE CGFloat
CGViewGetX2(UIView *view)
{
    return CGRectGetMaxX(view.frame);
}

CG_INLINE CGFloat
CGViewGetY2(UIView *view)
{
    return CGRectGetMaxY(view.frame);
}

CG_INLINE CGSize
CGViewGetSize(UIView *view)
{
    return view.frame.size;
}

CG_INLINE CGPoint
CGViewGetXY1(UIView *view)
{
    return view.frame.origin;
}

CG_INLINE CGPoint
CGViewGetXY2(UIView *view)
{
    return CGPointMake(CGViewGetX2(view), CGViewGetY2(view));
}

CG_INLINE void
CGViewTransY(UIView *view, CGFloat y)
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

CG_INLINE void
CGViewTransDY(UIView *view, CGFloat dy)
{
    CGRect frame = view.frame;
    frame.origin.y += dy;
    view.frame = frame;
}
CG_INLINE void
CGViewTransX(UIView *view, CGFloat x)
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeHeight(UIView *view, CGFloat height)
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeDHeight(UIView *view, CGFloat dheight)
{
    CGRect frame = view.frame;
    frame.size.height += dheight;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeWidth(UIView *view, CGFloat width)
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeDWidth(UIView *view, CGFloat dwidth)
{
    CGRect frame = view.frame;
    frame.size.width += dwidth;
    view.frame = frame;
}

#endif /* MyGenmetry_h */
