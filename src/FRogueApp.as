package  {
	import com.flashartofwar.frogue.maps.RandomMap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;

	/**
	 * @author jessefreeman
	 */
	public class FRogueApp extends Sprite {
		
		public function FRogueApp() {
			
			configureStage();
			trace("Hello World");
			
			var map:RandomMap = new RandomMap(10);
			trace(map);
			trace(map.tiles.join());
		}
		
		private function configureStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}
