#ifndef IMAGETOOLS_H
#define IMAGETOOLS_H

#include <godot_cpp/classes/sprite2d.hpp>

namespace godot {

class ImageTools : public Sprite2D {
	GDCLASS(ImageTools, Sprite2D)

private:
	//double time_passed;

protected:
	static void _bind_methods();

public:
	//ImageTools();
	//~GDExample();

	//void _process(double delta) override;
};

}

#endif