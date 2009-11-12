package  {
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

	/**
	 * @author jessefreeman
	 */
	public class FRogueApp extends Sprite {
		
		public function FRogueApp() {
			
			configureStage();
		}
		
		private function configureStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}
