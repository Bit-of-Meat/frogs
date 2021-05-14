SceneManager = {}

function SceneManager.load(scene)
   package.loaded[scene] = false

   require(scene)
end

return SceneManager