# TAM-Shader
An HLSL shader that emulates the look of a black-and-white, crosshatch-shaded drawing.

# Technical Explanation
This is an implementation of the technique outlined in <a href="https://core.ac.uk/download/pdf/42938945.pdf">this paper</a>.
The diffuse lighting is calculated by using the standard N-dot-L formula, then converting the result to a range of 0-6.
A texture is sampled from the TAM based on the result and then blended to create the effect.

A silhouette post-processing effect is applied to give the meshes an outline.

# Images
![Capture](https://user-images.githubusercontent.com/42875581/121116164-1bee3900-c7e4-11eb-83e5-32b032fff0a4.PNG)
![Capture2](https://user-images.githubusercontent.com/42875581/121116166-1d1f6600-c7e4-11eb-8038-9cf7f17b0065.PNG)
![Capture3](https://user-images.githubusercontent.com/42875581/121116170-1e509300-c7e4-11eb-8749-5f4b09974578.PNG)
![Capture4](https://user-images.githubusercontent.com/42875581/121116174-1f81c000-c7e4-11eb-8ec3-5137ad273c90.PNG)
