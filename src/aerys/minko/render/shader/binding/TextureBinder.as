package aerys.minko.render.shader.binding
{
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	
	import flash.utils.Dictionary;
	
	public class TextureBinder implements IBinder
	{
		private var _name		: String;
		private var _samplerId	: uint;
		
		/**
		 * @inheritDoc
		 */		
		public function get bindingName() : String
		{
			return _name;
		}
		
		public function TextureBinder(name		: String,
												samplerId	: uint)
		{
			_name		= name;
			_samplerId	= samplerId;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function set(vsConstData 	: Vector.<Number>,
							fsConstData 	: Vector.<Number>,
							textures		: Vector.<ITextureResource>,
							value			: Object) : void
		{
			textures[_samplerId] = TextureResource(value);
		}
	}
}