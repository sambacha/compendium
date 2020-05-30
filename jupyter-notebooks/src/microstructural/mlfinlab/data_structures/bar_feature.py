class BarFeature:
    """
    A wrapper for passing additional features to bar constructor
    """
    def __init__(self, name, function):
        if not isinstance(name, str):
            raise ValueError('name must be a string')
        if not callable(function):
            raise ValueError('function must be a callable')

        self.name = name
        self.function = function

    def compute(self, tick_df):
        return self.function(tick_df)
