class IndicatorTextureVariations extends Object;

var texture InViewTex;//when the target is on screen
var texture BehindViewTex;//when it is within the "screen" as the target is behind he player

var texture OffTopLeftViewTex;
var texture OffLeftViewTex;
var texture OffBottomLeftViewTex;
var texture OffBottomViewTex;
var texture OffBottomRightViewTex;
var texture OffRightViewTex;
var texture OffTopRightViewTex;
var texture OffTopViewTex;

function SetTextures(out texture topLeft, out texture left, out texture bottomLeft, out texture bottom, out texture bottomRight, out texture right, out texture topRight, out texture top, out texture behind, out texture inview, optional bool ShowIndicatorWhenOffScreen) {
    if(InViewTex != None) {
        inview = InViewTex;
    }

    if(!ShowIndicatorWhenOffScreen){
        if(OffTopLeftViewTex != None) {
			topLeft = OffTopLeftViewTex;
		}

		if(OffLeftViewTex != None) {
			left = OffLeftViewTex;
		}

		if(OffBottomLeftViewTex != None) {
			bottomLeft = OffBottomLeftViewTex;
		}

		if(OffBottomViewTex != None) {
			bottom = OffBottomViewTex;
		}

		if(OffBottomRightViewTex != None) {
			bottomRight = OffBottomRightViewTex;
		}

		if(OffRightViewTex != None) {
			right = OffRightViewTex;
		}

		if(OffTopRightViewTex != None) {
			topRight = OffTopRightViewTex;
		}

		if(OffTopViewTex != None) {
			top = OffTopViewTex;
		}

		if(BehindViewTex != None) {
			behind = BehindViewTex;
		}
    }
}
