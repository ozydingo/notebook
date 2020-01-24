## Models

At minimum, a torch model needs an `__init__` and `forward` function. The signatures of these functions is somewhat arbitrary but will generally take a torch.Tensor input, perform operations of these tensors using `torch.nn` layers, and output a `torch.Tensor`. `torch.Tensor` operations know how to compute their own gradients, so the backpropagation function is free for already defined mathematical operations.

## Datasets and Data Loaders

A pytorch dataset is an implemntation of `torch.utils.data.Dataset`. Implement at `__init__`, `__len__`, and `__getitem__`.

```py
class MyDataSet(torch.utils.data.Dataset):
  def __init__(...):
    pass

  def __len__():
    return length_of_dataset

  def __getitem__():
    return next_item
```

## Data transforms

A data transform can be a function or any callable class. A callable class is more common as it allows you to initialize parameters (note: why not just create a new function using those parameters?)

```py
class MyTransform:
  def __init__(self, ...):
    self.ratio = ...

  def __call__(self, object):
    return do_something_with(object)
```

Transforms can then be composed using `torchvision.transforms.Compose`:

```py
composed_transform = torchvision.transforms.Compose([
  MyTransform(ratio=2),
  MyOtherTransform(bias=0.2)
])
```

## Data loaders

A dataset can be iterated over directly:

```py
my_dataset = MyDataset(..., transform=composed_transform)
for ii in range(len(my_dataset)):
  sample = my_dataset[ii]
```

But more advanced features are available with a Data Loader

```py
dataloader = DataLoader(
  transformed_dataset, batch_size=4,
  shuffle=True, num_workers=4)

for batch in dataloader:
  pass
```

## PyTorch LSTM layer

```py
import torch

lstm_layer = torch.nn.LSTM(4, 2)
output_layer = torch.nn.Linear(2, 4)

vocab_size = 4
seq = [3,1,2]
input = torch.nn.functional.one_hot(torch.tensor(seq), vocab_size).view(len(seq), 1, -1).float()
(hidden, (final_h, final_c)) = lstm_layer(input)
output = torch.nn.functional.softmax(output_layer(hidden), dim=-1)

target_seq = [1,2,3]
target = torch.nn.functional.one_hot(torch.tensor(target_seq), vocab_size).view(len(target_seq), 1, -1).float()
_, target_classes = target.max(dim=-1)

torch.nn.functional.nll_loss(output.view(len(output), -1), target_classes)

```
