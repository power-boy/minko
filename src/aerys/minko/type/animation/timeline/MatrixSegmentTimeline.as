package aerys.minko.type.animation.timeline
{
	import aerys.minko.ns.minko_animation;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.type.math.Matrix4x4;

	use namespace minko_animation;
	
	public class MatrixSegmentTimeline implements ITimeline
	{
		private var _propertyName	: String;
		
		minko_animation var _timeTable		: Vector.<uint>
		minko_animation var _matrices		: Vector.<Matrix4x4>

		public function get propertyName()	: String	{ return _propertyName; }
		public function get duration()		: uint		{ return _timeTable[_timeTable.length - 1]; }
		
		public function MatrixSegmentTimeline(propertyName	: String,
											  timeTable 	: Vector.<uint>,
											  values		: Vector.<Matrix4x4>)
		{
			_propertyName	= propertyName;
			_timeTable		= timeTable;
			_matrices		= values;
		}

		public function updateAt(t : uint, scene : IScene) : void
		{
			var timeId		: uint = getIndexForTime(t);
			var timeCount	: uint = _timeTable.length;

			// change matrix value
			var out : Matrix4x4 = scene[_propertyName];
			if (!out)
			{
				throw new Error(
					"'" + _propertyName
					+ "' could not be found in scene node '"
					+ scene.name + "'"
				);
			}

			if (timeId == 0)
				Matrix4x4.copy(_matrices[0], out);
			else
				Matrix4x4.copy(_matrices[timeId - 1], out);
		}

		private function getIndexForTime(t : uint) : uint
		{
			// use a dichotomy to find the current frame in the time table.
			var timeCount 		: uint = _timeTable.length;
			var bottomTimeId	: uint = 0;
			var upperTimeId		: uint = timeCount;
			var timeId			: uint;

			while (upperTimeId - bottomTimeId > 1)
			{
				timeId = (bottomTimeId + upperTimeId) >> 1;

				if (_timeTable[timeId] > t)
					upperTimeId = timeId;
				else
					bottomTimeId = timeId;
			}

			return upperTimeId;
		}

		public function clone() : ITimeline
		{
			return new MatrixLinearTimeline(_propertyName, _timeTable.slice(), _matrices.slice());
		}

		public function reverse() : void
		{
			_timeTable.reverse();
			_matrices.reverse();
		}
	}
}
