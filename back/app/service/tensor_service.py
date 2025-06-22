import torch

def generate_tensor():
    tensor = torch.rand(10) * 10
    return tensor.tolist()
