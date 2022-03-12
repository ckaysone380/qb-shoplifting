# qb-shoplifting

A resource where you can shoplift items from stores
Where you can shoplift is configurable and how much you get from shoplifting is also Configurable

This resource uses qb-target
To make the target work you need to add these following lines in init.lua and Config.TargetModels 

![image](https://user-images.githubusercontent.com/78080230/158025052-fb2549a6-963f-4684-8076-4fc5e9bbd605.png)


PREVIEW: https://streamable.com/u6ez5i

        ["stealing"] = {
            models = {
                "v_ret_247shelves01",
                "v_ret_247shelves02",
                "v_ret_247shelves03",
                "v_ret_247shelves04",
                "v_ret_247shelves05"
            },
            options = {
                {
                    type = "client",
                    event = "qb-shoplifting:client:doStuff",
                    icon = "fas fa-toolbox",
                    label = "Shoplift",
                }
            },
            distance = 1.0
        },
        
