//
//  Shader.fsh
//  Cards Against Humanity
//
//  Created by Tim Carlson on 1/21/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
