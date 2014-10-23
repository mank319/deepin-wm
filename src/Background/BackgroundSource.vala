//
//  Copyright (C) 2014 Tom Beckmann
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

namespace Gala
{
	public class BackgroundSource : Object
	{
		public Meta.Screen screen { get; construct; }
		public Settings settings { get; construct; }

		internal int use_count { get; set; default = 0; }

		Gee.HashMap<int,Background> backgrounds;

		public BackgroundSource (Meta.Screen screen, string settings_schema)
		{
			Object (screen: screen, settings: new Settings (settings_schema));
		}

		construct
		{
			backgrounds = new Gee.HashMap<int,Background> ();

			screen.monitors_changed.connect (monitors_changed);
		}

		void monitors_changed ()
		{
			var n = screen.get_n_monitors ();
			var i = 0;

			foreach (var background in backgrounds.values) {
				if (i++ < n) {
					background.update_resolution ();
					continue;
				}

				background.changed.disconnect (background_changed);
				background.destroy ();
				// TODO can we remove from a list while iterating?
				backgrounds.unset (i);
			}
		}

		public Background get_background (int monitor_index)
		{
			string? filename = null;

			var style = settings.get_enum ("picture-options");
			if (style != GDesktop.BackgroundStyle.NONE) {
				var uri = settings.get_string ("picture-uri");
				if (Uri.parse_scheme (uri) != null)
					filename = File.new_for_uri (uri).get_path ();
				else
					filename = uri;
			}

			// Animated backgrounds are (potentially) per-monitor, since
			// they can have variants that depend on the aspect ratio and
			// size of the monitor; for other backgrounds we can use the
			// same background object for all monitors.
			if (filename == null || !filename.has_suffix (".xml"))
				monitor_index = 0;

			if (!backgrounds.has_key (monitor_index)) {
				var background = new Background (screen, monitor_index, filename, settings, (GDesktop.BackgroundStyle) style);

				background.changed.connect (background_changed);

				backgrounds[monitor_index] = background;
			}

			return backgrounds[monitor_index];
		}

		void background_changed (Background background)
		{
			background.changed.disconnect (background_changed);
			background.destroy ();
			backgrounds.unset (background.monitor_index);
		}

		public void destroy ()
		{
			screen.monitors_changed.disconnect (monitors_changed);

			foreach (var background in backgrounds) {
				background.changed.disconnect (background_changed);
				background.destroy ();
			}
		}
	}
}

