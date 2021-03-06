#import "substrate.h"
#import "preferences.h"

unsigned long long deepness = 0;

#define logStart0() do { NSLog(@"uroboro %d; %s {", deepness, __PRETTY_FUNCTION__); deepness++; } while (0)
#define logStart() do { NSLog(@"uroboro %lld; class: %@; method: %@; {", deepness, NSStringFromClass([self class]), NSStringFromSelector(_cmd)); deepness++; } while (0)
#define logEnd() do { deepness--; NSLog(@"uroboro; }%s", deepness?"":" //so deep"); } while (0)

// Dark keyboard background
%hook UIKBRenderConfig

- (BOOL)lightKeyboard {
	BOOL light = %orig();
	if (tweakIsEnabled()) {
		light = NO;
	}
	return light;
}

%end

// Dark PIN keypad in Settings
%hook DevicePINKeypad

-(id)initWithFrame:(CGRect)arg1 {
    id keypad = %orig;
    if (tweakIsEnabled()) {
		[self setBackgroundColor:[UIColor colorWithWhite:40/255.0 alpha:0.7]];
	}
	return keypad;
}

%end

// White UIPickerView text entries
@interface UIPickerTableViewTitledCell : UITableViewCell
-(void)setAttributedTitle:(NSAttributedString *)arg1;
@end

%hook UIPickerTableViewTitledCell

-(void)setAttributedTitle:(NSAttributedString *)arg1 {
	if (tweakIsEnabled()) {
		// white UIPickerView text
		NSAttributedString *title = [[NSAttributedString alloc] initWithString:[arg1 string] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
		%orig(title);
	}
	else {
		%orig(arg1);
	}
}

%end

%hook UIWebFormAccessory

// White chevrons
+(id)toolbarWithItems:(NSArray *)items {
	if (tweakIsEnabled()) {
		for (UIBarButtonItem *item in items) {
			[item setTintColor: [UIColor whiteColor]];
		}
	}
	return %orig(items);
}

// White Done button
-(void)layoutSubviews {
	if (tweakIsEnabled()) {
		NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
		[[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:0]; 
	}
	%orig;

}

%end

// dark PIN keypad in Settings
%hook DevicePINKeypad

-(id)initWithFrame:(CGRect)arg1 {
    id keypad = %orig;
    if (isEnabled()) {
		[self setBackgroundColor:[UIColor colorWithRed:40.0/255.0f green:40.0/255.0f blue:40.0/255.0f alpha:1.0f]];
	}    	
	return keypad;
}

%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	preferencesChanged();  // Not really
	// Register to receive changed notifications
	addObserver(preferencesChangedCallback, preferencesChangedNotification);
	[pool release];
}
